const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.updateAccess = functions.firestore
  .document('access/{accessId}')
  .onUpdate((change, context) => {

    const newValue = change.after.data();
    const customClaims = {
      level: newValue.level
    };


    // Set custom user claims on this update.
    return admin.auth().setCustomUserClaims(
               context.params.accessId, customClaims)
    .then(() => {
      console.log("Done!")
    })
    .catch(error => {
      console.log(error);
    });

});