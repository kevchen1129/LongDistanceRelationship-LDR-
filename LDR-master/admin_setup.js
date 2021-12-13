/*var admin = require('firebase-admin');

var serviceAccount = require("path/to/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://signuppage-4967d.firebaseio.com"
});

var app = admin.initializeApp();

const userEmail = 'user@example.com';

dynamicLink = FirebaseDynamicLinks.getInstance().createDynamicLink()
        .setLink(Uri.parse("https://www.example.com/"))
        .setDomainUriPrefix("https://example.page.link")
        // Open links with this app on Android
        .setAndroidParameters(new DynamicLink.AndroidParameters.Builder().build())
        // Open links with com.example.ios on iOS
        .setIosParameters(new DynamicLink.IosParameters.Builder("com.example.ios").build())
        .buildDynamicLink();

dynamicLinkUri = dynamicLink.getUri();


admin.auth().generatePasswordResetLink(userEmail, actionCodeSettings)
  .then((link) => {
    // Construct password reset email template, embed the link and send
    // using custom SMTP server.
    return sendCustomPasswordResetEmail(email, displayName, link);
  })
  .catch((error) => {
    // Some error occurred.
  });*/