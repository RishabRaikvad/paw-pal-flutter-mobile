const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// 🔔 Notify OWNER
exports.notifyOwner = functions.firestore
  .document("adoption_requests/{requestId}")
  .onCreate(async (snapshot, context) => {
    try {
      const data = snapshot.data();

      const ownerId = data.petOwnerId;
      const petName = data.petName;
      const buyerName = data.fullName;

      const userDoc = await admin.firestore()
        .collection("users")
        .doc(ownerId)
        .get();

      if (!userDoc.exists) return null;

      const tokens = userDoc.data().fcmTokens;

      if (!tokens || tokens.length === 0) return null;

      await admin.messaging().sendMulticast({
        notification: {
          title: "🐶 New Adoption Request",
          body: `${buyerName} wants to adopt ${petName}`
        },
        tokens: tokens
      });

      return null;

    } catch (error) {
      console.error("Error sending owner notification:", error);
      return null;
    }
});

// 🔔 Notify BUYER
exports.notifyBuyer = functions.firestore
  .document("adoption_requests/{requestId}")
  .onUpdate(async (change, context) => {
    try {
      const newData = change.after.data();
      const oldData = change.before.data();

      if (newData.status === oldData.status) return null;

      const buyerId = newData.petBuyerId;
      const petName = newData.petName;

      const userDoc = await admin.firestore()
        .collection("users")
        .doc(buyerId)
        .get();

      if (!userDoc.exists) return null;

      const tokens = userDoc.data().fcmTokens;

      if (!tokens || tokens.length === 0) return null;

      let title = "";
      let body = "";

      if (newData.status === "approved") {
        title = "🎉 Request Approved";
        body = `Your request for ${petName} is approved`;
      } else if (newData.status === "rejected") {
        title = "❌ Request Rejected";
        body = `Your request for ${petName} is rejected`;
      }

      if (!title) return null;

      await admin.messaging().sendMulticast({
        notification: { title, body },
        tokens: tokens
      });

      return null;

    } catch (error) {
      console.error("Error sending buyer notification:", error);
      return null;
    }
});