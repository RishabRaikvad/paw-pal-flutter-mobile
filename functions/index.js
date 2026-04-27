const { onDocumentCreated, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

admin.initializeApp();


// 🔔 Notify OWNER (when new request created)
exports.notifyOwner = onDocumentCreated("pet_adoption_request/{requestId}", async (event) => {
  try {
    console.log("🔥 notifyOwner triggered");

    const data = event.data.data();
    console.log("📦 Data:", data);

    if (!data) return;

    const ownerId = data.petOwnerId;
    const petName = data.petName || "your pet";
    const buyerName = data.fullName || "Someone";

    console.log("👤 Owner ID:", ownerId);

    if (!ownerId) return;

    const userDoc = await admin.firestore()
      .collection("users")
      .doc(ownerId)
      .get();

    if (!userDoc.exists) {
      console.log("❌ Owner not found");
      return;
    }

    const tokens = userDoc.data().fcmTokens || [];
    console.log("📱 Tokens:", tokens);

    if (tokens.length === 0) {
      console.log("❌ No tokens found");
      return;
    }

    const response = await admin.messaging().sendEachForMulticast({
      tokens: tokens,
      notification: {
        title: "🐶 New Adoption Request",
        body: `${buyerName} wants to adopt ${petName}`
      },
      data: {
        type: "adoption_request",
        petName: petName,
        buyerName: buyerName
      }
    });

    console.log("✅ Notification sent:", response);

  } catch (error) {
    console.error("❌ Error sending owner notification:", error);
  }
});


// 🔔 Notify BUYER (when status updated)
exports.notifyBuyer = onDocumentUpdated("pet_adoption_request/{requestId}", async (event) => {
  try {
    console.log("🔥 notifyBuyer triggered");

    const newData = event.data.after.data();
    const oldData = event.data.before.data();

    if (!newData || !oldData) return;

    if (newData.status === oldData.status) {
      console.log("⚠️ Status not changed");
      return;
    }

    const buyerId = newData.petBuyerId;
    const petName = newData.petName || "your pet";

    console.log("👤 Buyer ID:", buyerId);

    if (!buyerId) return;

    const userDoc = await admin.firestore()
      .collection("users")
      .doc(buyerId)
      .get();

    if (!userDoc.exists) {
      console.log("❌ Buyer not found");
      return;
    }

    const tokens = userDoc.data().fcmTokens || [];
    console.log("📱 Tokens:", tokens);

    if (tokens.length === 0) {
      console.log("❌ No tokens found");
      return;
    }

    let title = "";
    let body = "";

    if (newData.status === "approved") {
      title = "🎉 Request Approved";
      body = `Your request for ${petName} is approved`;
    } else if (newData.status === "rejected") {
      title = "❌ Request Rejected";
      body = `Your request for ${petName} is rejected`;
    }else if (newData.status === "completed") {  // ✅ NEW
           title = "🐾 Adoption Successful";
           body = `Congratulations! You are now the owner of ${petName}`;
      }


    if (!title) {
      console.log("⚠️ No valid status");
      return;
    }

    const response = await admin.messaging().sendEachForMulticast({
      tokens: tokens,
      notification: { title, body },
      data: {
        type: "adoption_status",
        petName: petName,
        status: newData.status
      }
    });

    console.log("✅ Notification sent:", response);

  } catch (error) {
    console.error("❌ Error sending buyer notification:", error);
  }
});