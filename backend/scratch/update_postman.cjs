const fs = require('fs');

const path = 'MediApp_Complete_API.postman_collection.json';
const data = JSON.parse(fs.readFileSync(path, 'utf8'));

const sosItem = {
  "name": "Patient - SOS & Emergency",
  "item": [
    {
      "name": "Set Emergency Contact",
      "request": {
        "method": "PATCH",
        "header": [
          { "key": "Authorization", "value": "bearer {{ACCESS_TOKEN}}" },
          { "key": "Content-Type", "value": "application/json" }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"name\": \"John Doe\",\n  \"phone\": \"+201012345678\",\n  \"contactMethod\": \"whatsapp\"\n}"
        },
        "url": { "raw": "{{baseUrl}}/patients/emergency-contact", "host": ["{{baseUrl}}"], "path": ["patients", "emergency-contact"] }
      }
    },
    {
      "name": "Trigger SOS",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Authorization", "value": "bearer {{ACCESS_TOKEN}}" },
          { "key": "Content-Type", "value": "application/json" }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"lat\": 31.2156,\n  \"lng\": 29.9553\n}"
        },
        "url": { "raw": "{{baseUrl}}/patients/sos", "host": ["{{baseUrl}}"], "path": ["patients", "sos"] }
      }
    }
  ]
};

const sessionItem = {
  "name": "Booking - Sessions (QR & Permissions)",
  "item": [
    {
      "name": "Generate QR Session Token (Patient)",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Authorization", "value": "bearer {{ACCESS_TOKEN}}" }
        ],
        "url": { "raw": "{{baseUrl}}/bookings/{{bookingId}}/generate-qr", "host": ["{{baseUrl}}"], "path": ["bookings", "{{bookingId}}", "generate-qr"] }
      }
    },
    {
      "name": "Start Session (Doctor)",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Authorization", "value": "bearer {{DOCTOR_ACCESS_TOKEN}}" },
          { "key": "Content-Type", "value": "application/json" }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"sessionToken\": \"1234abcd5678efgh\"\n}"
        },
        "url": { "raw": "{{baseUrl}}/bookings/start-session", "host": ["{{baseUrl}}"], "path": ["bookings", "start-session"] }
      }
    },
    {
      "name": "End Session",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Authorization", "value": "bearer {{ACCESS_TOKEN}}" }
        ],
        "url": { "raw": "{{baseUrl}}/bookings/{{bookingId}}/end-session", "host": ["{{baseUrl}}"], "path": ["bookings", "{{bookingId}}", "end-session"] }
      }
    }
  ]
};

data.item.push(sosItem);
data.item.push(sessionItem);

fs.writeFileSync(path, JSON.stringify(data, null, 2));
console.log('Postman collection updated successfully!');
