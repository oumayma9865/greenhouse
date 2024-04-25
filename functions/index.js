const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  // Vérifier les autorisations
  if (!context.auth || !context.auth.token.admin) {
    return { error: 'Unauthorized' };
  }

  const uid = data.uid;

  try {
    // Supprimer l'utilisateur de la table d'authentification Firebase
    await admin.auth().deleteUser(uid);
    return { success: true };
  } catch (error) {
    console.error('Error deleting user:', error);
    return { error: 'Could not delete user.' };
  }
});
