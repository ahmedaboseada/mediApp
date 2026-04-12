import dotenv from 'dotenv';
dotenv.config();

const analyzeMedications = async (newMedications, currentAllergies = []) => {
    try {
        const apiKey = process.env.GEMINI_API_KEY;
        if (!apiKey) {
            console.error('GEMINI_API_KEY is missing from .env');
            return;
        }

        const modelStr = 'gemini-3-flash-preview';
        const url = `https://generativelanguage.googleapis.com/v1beta/models/${modelStr}:generateContent?key=${apiKey}`;

        const prompt = `
            You are a medical AI assistant.
            The patient is taking the following medications: ${newMedications.join(', ')}.
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

        console.log("Sending medicines to Gemini...");
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                contents: [{ parts: [{ text: prompt }] }],
                generationConfig: {
                    responseMimeType: 'application/json'
                }
            })
        });

        const data = await response.json();
        if (data.error) throw new Error(data.error.message);

        const candidateText = data.candidates?.[0]?.content?.parts?.[0]?.text;

        console.log("\n--- GEMINI AI RESPONSE ---");
        console.log(candidateText);
        console.log("--------------------------\n");
    } catch (error) {
        console.error('Error:', error);
    }
};

// Testing two high-risk interaction medicines
analyzeMedications(['Warfarin', 'Aspirin']);
