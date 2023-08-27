const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { getMessaging } = require('firebase-admin/messaging');
admin.initializeApp();

/*exports.updateAccess = functions.firestore
  .document('access/{accessId}')
  .onUpdate((change, context) => {

    const newValue = change.after.data();
    const customClaims = {
      level: newValue.level
    };

    // Set custom user claims on this update.
    return admin.auth().setCustomUserClaims(
               context.params.accessId, { admin: true })
    .then(() => {
      console.log("Done!")
    })
    .catch(error => {
      console.log(error);
    });

});*/

exports.sendNotification = functions.https.onCall((data, context) => {

          const message = {
            notification: {
              title: data["title"],
              body: "Controlla la sezione ordine per saperne di più",
            },
            token: data["token"],
          };
          
         return getMessaging().send(message).catch(error => {
            throw new functions.https.HttpsError('internal', error);
          });

  });




  
