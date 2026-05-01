const fs = require('fs');

const path = 'MediApp_Complete_API.postman_collection.json';
const data = JSON.parse(fs.readFileSync(path, 'utf8'));

// Check if it already exists to avoid duplicates
const exists = data.item.find(i => i.name === "Doctor - Patient Medications (Elevated)");
if (exists) {
    console.log("Already exists.");
    process.exit(0);
}

const docMedsItem = {
  "name": "Doctor - Patient Medications (Elevated)",
  "item": [
    {
      "name": "Get Patient Medications",
      "request": {
        "method": "GET",
        "header": [
          { "key": "Authorization", "value": "bearer {{DOCTOR_ACCESS_TOKEN}}" }
        ],
        "url": { 
            "raw": "{{baseUrl}}/medications?patientId={{patientId}}", 
            "host": ["{{baseUrl}}"], 
            "path": ["medications"],
            "query": [
                { "key": "patientId", "value": "{{patientId}}" }
            ]
        }
      }
    },
    {
      "name": "Add Patient Medication (Requires Active Session)",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Authorization", "value": "bearer {{DOCTOR_ACCESS_TOKEN}}" },
          { "key": "Content-Type", "value": "application/json" }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"patientId\": \"{{patientId}}\",\n  \"name\": \"Panadol Extra\",\n  \"type\": \"tablet\",\n  \"dosage\": \"500mg\",\n  \"frequency\": \"daily\",\n  \"daily\": [\"08:00\", \"20:00\"]\n}"
        },
        "url": { "raw": "{{baseUrl}}/medications", "host": ["{{baseUrl}}"], "path": ["medications"] }
      }
    },
    {
      "name": "Update Patient Medication (Requires Active Session)",
      "request": {
        "method": "PUT",
        "header": [
          { "key": "Authorization", "value": "bearer {{DOCTOR_ACCESS_TOKEN}}" },
          { "key": "Content-Type", "value": "application/json" }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"patientId\": \"{{patientId}}\",\n  \"dosage\": \"1000mg\"\n}"
        },
        "url": { "raw": "{{baseUrl}}/medications/{{medicineId}}", "host": ["{{baseUrl}}"], "path": ["medications", "{{medicineId}}"] }
      }
    },
    {
      "name": "Delete Patient Medication (Requires Active Session)",
      "request": {
        "method": "DELETE",
        "header": [
          { "key": "Authorization", "value": "bearer {{DOCTOR_ACCESS_TOKEN}}" },
          { "key": "Content-Type", "value": "application/json" }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"patientId\": \"{{patientId}}\"\n}"
        },
        "url": { "raw": "{{baseUrl}}/medications/{{medicineId}}", "host": ["{{baseUrl}}"], "path": ["medications", "{{medicineId}}"] }
      }
    }
  ]
};

data.item.push(docMedsItem);

fs.writeFileSync(path, JSON.stringify(data, null, 2));
console.log('Postman collection updated with Doctor Medications successfully!');
