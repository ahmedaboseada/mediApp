import Notification from '../models/notification.model.js';
import patientModel from '../models/patient.model.js';
import Medicine from '../models/medicine.model.js';

/**
 * Calls Gemini API via REST to extract active ingredients and check for interactions/allergies.
 * This function should be called asynchronously so it does not block the API response.
 */
export const analyzeMedications = async (patientId, newMedications, currentAllergies = []) => {
    try {
        const apiKey = process.env.GEMINI_API_KEY;
        if (!apiKey) {
            console.warn('GEMINI_API_KEY is not set. Skipping AI medication analysis.');
            return;
        }

        const modelStr = 'gemini-2.5-flash';
        const url = `https://generativelanguage.googleapis.com/v1beta/models/${modelStr}:generateContent?key=${apiKey}`;

        const medicines = await Medicine.find({ _id: { $in: newMedications } }).select('name').lean();
        const medicineNames = medicines.map(m => m.name);

        const prompt = `
            You are a medical AI assistant.
            The patient is taking the following medications: ${medicineNames.join(', ')}.
            The patient has the following known allergies: ${currentAllergies.join(', ')}.

            Please analyze this and return STRICTLY a JSON object with the following schema:
            {
                "activeIngredients": ["list", "of", "ingredients"],
                "interactionsFound": boolean,
                "allergyAlertsFound": boolean,
                "warnings": ["Array of concise warning strings explaining the interactions or allergy matches, if any. Otherwise empty array."]
            }
            Do not include any Markdown formats, backticks, or extra text. Return ONLY the raw JSON string.
        `;

        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                contents: [{ parts: [{ text: prompt }] }],
                generationConfig: {
                    responseMimeType: 'application/json',
                }
            })
        });

        if (!response.ok) {
            const errBody = await response.text();
            throw new Error(`Gemini API error: ${response.status} ${errBody}`);
        }

        const data = await response.json();

        // Extract raw JSON text from Gemini response
        const candidateText = data.candidates?.[0]?.content?.parts?.[0]?.text;
        if (!candidateText) {
            console.warn('No text returned from Gemini API.');
            return;
        }

        const parsed = JSON.parse(candidateText.trim());

        const patient = await patientModel.findById(patientId);
        if (!patient) return;

        // Merge active ingredients without duplicates
        if (parsed.activeIngredients && Array.isArray(parsed.activeIngredients)) {
            const currentIngredients = new Set(patient.activeIngredients || []);
            parsed.activeIngredients.forEach(ing => currentIngredients.add(ing.toLowerCase().trim()));
            patient.activeIngredients = Array.from(currentIngredients);
            await patient.save();
        }

        // Create Notifications if there are warnings
        if ((parsed.interactionsFound || parsed.allergyAlertsFound) && parsed.warnings && parsed.warnings.length > 0) {
            for (const warning of parsed.warnings) {
                await Notification.create({
                    type: 'healthAlert',
                    header: 'AI Medication Alert',
                    message: warning,
                    userId: patient.userId
                });
            }
        }

    } catch (error) {
        console.error('Error in analyzeMedications:', error);
    }
};
