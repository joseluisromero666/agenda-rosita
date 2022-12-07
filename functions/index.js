const firebase_client = require("firebase");
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const firebaseConfig = {
  apiKey: "AIzaSyCECXPwbdBhPZDxYj-NEgXi2bC0UgwsmB4",
  authDomain: "agenda-rosita.firebaseapp.com",
  projectId: "agenda-rosita",
  storageBucket: "agenda-rosita.appspot.com",
  messagingSenderId: "46215472945",
  appId: "1:46215472945:web:bcb5a0cc05a2dbed0c7210",
  measurementId: "G-LTFN5LNKW1",
};

firebase_client.initializeApp(firebaseConfig);

exports.createAuthAccount = functions.firestore
  .document("/users/{documentId}")
  .onCreate((snap, context) => {
    const user = snap.data();
    try {
      if (user.role == "Administrador" || user.role == "Cliente") {
        admin
          .auth()
          .createUser({
            uid: context.params.documentId,
            email: user.email,
            emailVerified: false,
            phoneNumber: user.phone,
            displayName: user.name,
            photoURL: user.urlImg,
            password: "alekgerlkg3423ker4lkget",
            disabled: false,
          })
          .then((userRecord) => {
            console.log("Succesfully created new user:", userRecord.uid);
            firebase_client.auth().sendPasswordResetEmail(user.email);
          })
          .catch((err) => {
            console.log("Error creating new user:", err);
          });
      }
    } catch (e) {
      console.error(e);
    }
  });

exports.updateUser = functions.firestore
  .document("/users/{documentId}")
  .onUpdate((snap, context) => {
    const newUser = snap.after.data();
    const oldUser = snap.before.data();
    functions.logger.log("User", context.params.documentId, newUser);
    try {
      if (newUser.isActive == oldUser.isActive) {
        admin
          .firestore()
          .collection("audit")
          .add({
            oldUser: oldUser,
            newUser: newUser,
            kind: "Update",
            date: new Date().toISOString().slice(0, 10),
          })
          .then((userRecord) =>
            console.log("Succesfully updated:", userRecord.uid)
          )
          .catch((e) => console.error(e));
        if (
          (oldUser.role == "Administrador" || oldUser.role == "Cliente") &&
          oldUser.email != newUser.email
        ) {
          admin
            .auth()
            .updateUser(context.params.documentId, { email: newUser.email });
        }
      } else if (!newUser.isActive) {
        admin
          .firestore()
          .collection("audit")
          .add({
            user: newUser,
            kind: "Delete",
            date: new Date().toISOString().slice(0, 10),
          })
          .then((userRecord) =>
            console.log("Succesfully deleted:", userRecord.uid)
          )
          .catch((e) => console.error(e));
        if (oldUser.role == "Administrador" || oldUser.role == "Cliente") {
          admin
            .auth()
            .updateUser(context.params.documentId, { disabled: true });
        }
      } else if (newUser.isActive) {
        admin
          .firestore()
          .collection("audit")
          .add({
            user: newUser,
            kind: "Restore",
            date: new Date().toISOString().slice(0, 10),
          })
          .then((userRecord) =>
            console.log("Succesfully restored:", userRecord.uid)
          )
          .catch((e) => console.error(e));
        if (oldUser.role == "Administrador" || oldUser.role == "Cliente") {
          admin
            .auth()
            .updateUser(context.params.documentId, { disabled: false });
        }
      } 
    } catch (e) {
      console.error(e);
    }
  });

exports.deleteUser = functions.firestore
  .document("/users/{documentId}")
  .onDelete((snap, context) => {
    const user = snap.data();
    try {
      admin
        .firestore()
        .collection("audit")
        .add({
          user: user,
          kind: "Delete",
          date: new Date().toISOString().slice(0, 10),
        })
        .then((userRecord) =>
          console.log("Succesfully deleted:", userRecord.uid)
        )
        .catch((e) => console.error(e));
      if (user.role == "Administrador" || user.role == "Cliente") {
        admin.auth().updateUser(context.params.documentId, { disabled: true });
      }
    } catch (e) {
      console.error(e);
    }
  });
