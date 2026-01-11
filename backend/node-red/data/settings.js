
const admin = require("firebase-admin");

module.exports = {
  flowFile: "flows.json",

  functionGlobalContext: {
    firebase_admin: (() => {
      try {
        //const serviceAccount = require("/data/serviceAccount.json");
const serviceAccount=process.env.FIREBASE_SERVICE_ACCOUNT;
        if (!serviceAccount || !serviceAccount.project_id) {
          console.error("Invalid service account JSON");
          return null;
        }

        if (!admin.apps.length) {
          admin.initializeApp({
            credential: admin.credential.cert(serviceAccount),
          });
        }

        console.log(
          "Firebase Admin initialized:",
          serviceAccount.project_id
        );
        return admin;
      } catch (err) {
        console.error("Firebase Admin init failed:", err.message);
        return null;
      }
    })(),
  },

  flowFilePretty: true,
  //for deploy
   uiPort: process.env.PORT || 1880,

  diagnostics: { enabled: true, ui: true },

  logging: {
    console: { level: "info", metrics: false, audit: false },
  },

  globalFunctionTimeout: 0,
  functionTimeout: 0,
};
