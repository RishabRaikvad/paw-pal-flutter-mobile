const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();

// 🔔 Notify OWNER
exports.notifyOwner = onDocumentCreated("adoption_requests/{requestId}", async (event) => {
  try {
    const data = event.data.data();

    const ownerId = data.petOwnerId;
    const petName = data.petName;
    const buyerName = data.fullName;

    const userDoc = await admin.firestore()
      .collection("users")
      .doc(ownerId)
      .get();

    if (!userDoc.exists) return;

    const tokens = userDoc.data().fcmTokens;

    if (!tokens || tokens.length === 0) return;

    await admin.messaging().sendMulticast({
      notification: {
        title: "🐶 New Adoption Request",
        body: `${buyerName} wants to adopt ${petName}`
      },
      tokens: tokens
    });

  } catch (error) {
    console.error("Error sending owner notification:", error);
  }
});

// 🔔 Notify BUYER
exports.notifyBuyer = onDocumentUpdated("adoption_requests/{requestId}", async (event) => {
  try {
    const newData = event.data.after.data();
    const oldData = event.data.before.data();

    if (newData.status === oldData.status) return;

    const buyerId = newData.petBuyerId;
    const petName = newData.petName;

    const userDoc = await admin.firestore()
      .collection("users")
      .doc(buyerId)
      .get();

    if (!userDoc.exists) return;

    const tokens = userDoc.data().fcmTokens;

    if (!tokens || tokens.length === 0) return;

    let title = "";
    let body = "";

    if (newData.status === "approved") {
      title = "🎉 Request Approved";
      body = `Your request for ${petName} is approved`;
    } else if (newData.status === "rejected") {
      title = "❌ Request Rejected";
      body = `Your request for ${petName} is rejected`;
    }

    if (!title) return;

    await admin.messaging().sendMulticast({
      notification: { title, body },
      tokens: tokens
    });

  } catch (error) {
    console.error("Error sending buyer notification:", error);
  }
});