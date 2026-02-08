// Make sure to install the necessary packages:
// npm install @google/generative-ai dotenv

import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from 'dotenv';

// Load environment variables from a .env file
dotenv.config();

// Initialize the model
const apiKey = process.env.GOOGLE_GEMINI_API_KEY;
if (!apiKey) {
    throw new Error("GOOGLE_GEMINI_API_KEY is not set in your environment variables.");
}

const genAI = new GoogleGenerativeAI(apiKey);
export const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

/**
 * Main function to generate a reminder time using the Gemini API.
 */
async function main() {
    try {

        // // --- User and Task Data ---
        // const userStats = {
        //     bestTimeOfDay: "10:00 PM",
        //     avgCompletionDelay: "3 hours",
        //     productiveDays: ["Monday", "Tuesday", "Friday"],
        // };
        // const taskDeadline = "2023-10-01T12:00:00.000Z";

        // // --- REFINED PROMPT ---
        // // This prompt is more direct and focuses on the output format.
        // const prompt = `
        // Based on the following user data and task deadline, determine the optimal time to send a reminder.

        // User Data:
        // - Best time to complete tasks: ${userStats.bestTimeOfDay}
        // - Average completion delay: ${userStats.avgCompletionDelay}
        // - Most productive days: ${userStats.productiveDays.join(", ")}

        // Task Deadline: ${taskDeadline}

        // Your task is to calculate an appropriate reminder time that occurs before the deadline and aligns with the user's productive habits.

        // Return ONLY a JSON object in the following format. Do not include any other text, explanations, or markdown formatting.
        // {
        //   "bestTimeToSendEmail": "YYYY-MM-DDTHH:mm:ss.sssZ"
        // }
        // `;

        // // --- API CALL WITH generationConfig ---
        // console.log("Sending request to Gemini...");
        // const result = await model.generateContent({
        //     contents: [{ role: "user", parts: [{ text: prompt }] }],
        //     // This config forces the model to output only JSON
        //     generationConfig: {
        //         responseMimeType: "application/json",
        //     },
        // });

        // const response = result.response;
        // const jsonText = response.text();

        // console.log("--- Raw JSON Response from Gemini ---");
        // console.log(jsonText);
        // console.log("------------------------------------");

        // // --- PARSE AND USE THE JSON ---
        // // The response text is now a clean JSON string
        // const reminderData = JSON.parse(jsonText);

        // console.log("\n--- Parsed Reminder Object ---");
        // console.log(reminderData);
        // console.log(`Optimal reminder time: ${reminderData.bestTimeToSendEmail}`);
        // console.log("------------------------------");
        // console.log(response.text().bestTimeToSendEmail);
        // console.log(JSON.parse(response.text()).bestTimeToSendEmail);
        

    } catch (error) {
        console.error("--- An error occurred ---");
        console.error("Error calling the Google Generative AI API:", error.message);
        console.error("--------------------------");
    }
}

// main();



