# MediApp — Healthcare Management Platform

MediApp is a graduation project from the Faculty of Science, Alexandria University (awarded Grade A): a full healthcare management platform connecting patients, doctors, and admins. The repository contains the Flutter mobile app (`frontend/`) and the Node.js backend (`backend/`), which delivers 33 features across 10 REST API modules.

Built by a five-member backend team under Agile Scrum, led by [@ahmedaboseada](https://github.com/ahmedaboseada) as Project Manager and Team Leader.

## Features

- **Multi-role platform** — separate modules for patients, doctors, and admins, with role-based access control (`user`, `patient`, `doctor`, `admin`).
- **Authentication & security** — JWT access/refresh tokens, OTP sign-in, two-factor authentication, Google OAuth2, email confirmation, and OTP-based password reset. Secured with bcrypt, Helmet, CORS, and rate limiting.
- **Appointments & availability** — doctors define consultation fees, working days, and hourly schedules; patients book from real-time availability, with a weekly availability-reset cron job.
- **Medical records & health profile** — patients manage their health data and can link family members/dependents to a primary account.
- **QR-based record sharing** — generate a share link and QR code for a medical record, plus downloadable PDF health passports (QRCode + PDFKit).
- **AI medication analysis** — a Google Gemini integration (`backend/src/utils/ai.util.js`) extracts active ingredients for a patient's medications and flags potential interaction or allergy matches in the data. These AI outputs are informational only; they are not medical advice and are not validated clinical decisions.
- **Payments** — Paymob integration.
- **Notifications** — email (SMTP via Nodemailer) and SMS (Twilio).
- **Media uploads** — Cloudinary.
- **In-app messaging and doctor reviews.**

## Tech Stack

| Layer | Tools |
|---|---|
| Backend | Node.js, Express 5 |
| Database | MongoDB (Mongoose) |
| Auth | JWT, OTP, 2FA, Google OAuth2, bcrypt |
| AI | Google Gemini (`gemini-2.5-flash`) |
| Payments | Paymob |
| Docs/Files | PDFKit, QRCode, Cloudinary |
| Mobile | Flutter (Dart) in `frontend/` |
| Deployment | Vercel (`@vercel/node`) |
| Testing | Jest |

## Project Structure

```
mediApp/
├── frontend/                     # Flutter mobile app
└── backend/
    ├── index.js                  # Vercel serverless entry point
    ├── vercel.json
    └── src/
        ├── app.controller.js     # app bootstrap, middleware, route mounting
        ├── config/               # DB, Cloudinary, env
        ├── middlewares/          # auth, validation, error handling
        ├── models/               # shared Mongoose models
        └── modules/              # 10 feature modules:
            ├── userModel/            # auth, profiles, settings
            ├── patientModel/         # patient accounts & dependents
            ├── doctorModel/          # onboarding, fees, availability
            ├── adminModel/           # administration
            ├── bookingModel/         # appointments
            ├── medicineModel/        # medicines catalog
            ├── healthModel/          # health records
            ├── exportModel/          # QR sharing + PDF health passport
            ├── reviewModel/          # doctor reviews
            └── messageModel/         # in-app messaging
```

## Getting Started (Backend)

Note: these steps were prepared by inspecting the code and have not been run end-to-end; some services require their own accounts and keys before the app fully works.

**Prerequisites:** Node.js, a MongoDB connection string.

```bash
cd backend
npm install
```

Create a `.env` file in `backend/`. Variable names below are the ones the code reads:

```env
NODE_ENV=development
PORT=3000
MONGO_URI=<your-mongodb-uri>            # local/development
MONGO_URI_ONLINE=<your-mongodb-uri>     # hosted database

JWT_ACCESS_USER_SECRET=<secret>
JWT_ACCESS_ADMIN_SECRET=<secret>
JWT_REFRESH_USER_SECRET=<secret>
JWT_REFRESH_ADMIN_SECRET=<secret>
JWT_EMAIL_CONFIRM_SECRET=<secret>

CLOUDINARY_CLOUD_NAME=<your-cloud-name>
CLOUDINARY_API_KEY=<your-key>
CLOUDINARY_API_SECRET=<your-secret>

SMTP_HOST=<your-smtp-host>
SMTP_PORT=<your-smtp-port>
SMTP_USER=<your-smtp-user>
SMTP_PASS=<your-smtp-password>

GEMINI_API_KEY=<your-gemini-key>            # AI medication analysis
PAYMOB_API_KEY=<your-paymob-key>            # payments
PAYMOB_INTEGRATION_ID=<your-integration-id>
TWILIO_ACCOUNT_SID=<your-sid>               # SMS
TWILIO_AUTH_TOKEN=<your-token>
TWILIO_PHONE_NUMBER=<your-twilio-number>
```

Run:

```bash
npm run dev     # development with nodemon
npm start       # production
npm test        # Jest
```

## Documentation

- [`backend/requirements.txt`](backend/requirements.txt) — full functional and non-functional requirements
- [`ENTERPRISE_TECHNICAL_DOCUMENTATION.md`](ENTERPRISE_TECHNICAL_DOCUMENTATION.md)
- [`SENIOR_PROJECT_TECHNICAL_DOCUMENTATION.md`](SENIOR_PROJECT_TECHNICAL_DOCUMENTATION.md)
