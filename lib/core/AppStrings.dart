import 'dart:io';

abstract class AppStrings {
  static const String appName = "Paw Pal";
  static const String appEmail = "maulikjp@gmail.com";
  static const String yes = "Yes";
  static const String no = "No";
  static const String btnContinue = "Continue";
  static const String incorrectOtp = "OTP is incorrect";
  static const String noInternet = "No internet connection";
  static const String errorSomething = "Something went wrong";
  static const String lookLikeErrorText = "Looks like an error occurred";
  static const retry = "Retry";
  static const String otpSuccess = "OTP Sent Successfully";
  static const String home = "Home";
  static const String earning = "Earnings";
  static const String notification = "Notifications";
  static const String profile = "Profile";
  static const String faq = "FAQs";
  static const String contactUS = "Contacts Us";
  static const String noFaq = "No Faq's Found";
  static const String hello = "Hello";
  static const String validAmount = "Amount too low — it should be 50 or more.";
  static const String enterAmountError = "Please Enter Amount For WithDraw Money";
  static const String batteryOptimizationIsEnabled =
      "Battery optimization is enabled. Please select No restrictions for better performance.";
  static const String logoutFailed = "Logout Failed, Please try again.";
  static const String instruction = "•  Instruction";
  static const String customer = "Customer Name";
  static const String noInterNet = "No Internet Connection !";
  static const String noInterNetContent = "No internet connection was found. Check your connection or try again.";

  static String greeting(String? name) {
    return "Hey, ${name ?? ''} 👋";
  }
  static const String googleDirectionsBaseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';
  static String googleDirectionsUrl({
    required String origin,
    required String destination,
    String waypoints = '',
    required String apiKey,
  }) {
    return '$googleDirectionsBaseUrl?origin=$origin&destination=$destination$waypoints&key=$apiKey';
  }

  static Uri buildMapLaunchUrl({
    required double currentLat,
    required double currentLng,
    required double destinationLat,
    required double destinationLng,
  }) {
    if (Platform.isIOS) {
      return Uri.parse(
        'maps://?saddr=$currentLat,$currentLng&daddr=$destinationLat,$destinationLng&dirflg=d',
      );
    } else {
      return Uri.parse(
        'https://www.google.com/maps/dir/?api=1'
            '&origin=$currentLat,$currentLng'
            '&destination=$destinationLat,$destinationLng'
            '&travelmode=driving',
      );
    }
  }
  static const String notificationOnline = 'You are Online';
  static const String firebaseNotificationIcon =
      'com.google.firebase.messaging.default_notification_icon';
  static const String statusReject = "Rejected";
  static const String statusPendingText = "Pending";
  static const String statusExpired = "Expired";

  /// Api ErrorMessage
  static const String checkEmailAddressOrPassword =
      "Please check email address or password";
  static const String checkValidationFailed = "Your validation is Failed";
  static const String checkYourAccountBan =
      "Your account is ban, please contact to admin";
  static const String badRequest = "Please check your details";
  static const String emailAlreadyTaken =
      "Your email address is already taken, please try with different email.";
  static const String invalidVerificationCode = "Invalid verification code";
  static const String walletBalanceInsufficient = "Insufficient Wallet Balance";
  static const String notFound = "user data not found";
  static const String internalServerError = "Internal server error";
  static const String locationAlreadyAdded = "Location already added";
  static const String internetConnectionError =
      "Please check your internet connection.";
  static const String profileSelectionError =
      "1. File size is not more then of 5 MB\n2. File type is Jpeg,Jpg or Png";
  static const String uploadImageError = "Image uploading failed";
  static const String uploadImageSuccess = "Image uploaded successfully";
  static const String emptyDataDefaultError = "No data found, please try again";
  static const String alreadyInGame = "User is already in Game";
  static const String alreadyJoined = "User is already Joined";
  static const String sessionExpired = "Your session is expired";

  // login Screen Text
  static const String welcomeText = "Hey, Welcome";
  static const String welcome = "Welcome 👋";
  static const String loginSecondaryText =
      "With a valid number,you can access deliveries,and our other services";
  static const String mobileNumber = "Mobile Number";
  static const countryCode = "+1";
  static const String btnlogin = "LOGIN";
  static const String otpVerificationTitle = "OTP code verification 🔑";
  static const String submit = "Submit";
  static const String changePhoneNumber = "Change phone number?";
  static const String resend = "Resend";
  static const String editHere = " edit here";
  static const String phoneNumberValidation = "Please enter phone number";
  static const String phoneNumberValidation01 =
      "Please enter a valid phone number";
  static const String resendFailed = "Resend failed";
  static const String verificationFailed = "Verification failed";
  static const String loginSuccess = "Login Successfully";
  static const String loginFail = "Failed to Login";
  static const String resendOtpSuccess = "Resend OTP Successfully";

  // OTP Verification Text
  static const String enterTheOTP = "Enter the OTP";
  static const String receiveOtpText = "Didn't receive the OTP?";
  static const String resendOtpText = "Resend OTP";
  static const String sentCode = "We sent a code to";

  // User Detail Screen Text
  static const String firstName = "First Name";
  static const String lastName = "Last Name";
  static const String emailId = "Email Id";
  static const String phoneNumber = "Phone Number";
  static const String getStarted = "Get Started";
  static const String btnRegister = "REGISTER";
  static const String allowSmsUpdates =
      "Allow Rapidlift to send updates on SMS";

  // login screen
  static const String chooseYourWay = "Choose Your Way";
  static const String tryingToFindLocation = "Trouble Accessing Location";
  static const String allowLocation = "Allow Location";
  static const String enterLocation = "Enter location manually";
  static const String currentlyUnableAccessLocation =
      "To offer location-based services like nearby drivers or delivery updates, we may need your location.";

  /// Onboarding Screen Text

  static const String phoneNumberRequired = "Please enter your mobile number";
  static const String invalidPhoneNumber = "Please enter a valid phone number";
  static const String otpSent = "OTP sent successfully";
  static const String otpResent = "OTP resent successfully to ";
  static const String otpRequired = "Please enter the OTP";
  static const String otpInvalid = "Invalid OTP Please try again";
  static const String otpVerificationFailed = "OTP verification failed";
  static const String otpExpired = "OTP has expired, Please request a new code";

  static const String enterPhoneNumber = "Enter Phone Number";
  static const String enterFirstName = "Enter First Name";
  static const String validFirstName = "Enter valid First Name";
  static const String enterLastName = "Enter Last Name";
  static const String validLastName = "Enter valid Last Name";
  static const String enterEmail = "Enter a email address";
  static const String validEmail = "Enter a valid email address";
  static const String validPhoneNumber = "Enter a valid mobile number";
  static const String profileUpdate = "Profile Update Successfully";
  static const String logOutText = "Logout successful";
  static const String deleteUser = "user delete Successfully";
  static const String loginSuccessful = "Login Successful";
  static const String loginFailed = "Login Failed";
  static const String selfieError = "Please Take Selfie";
  static const String front = "Front";
  static const String back = "Back";
  static const String photo = "Photo";
  static const String expireDate = "Expiry Date";
  static const String documentNumber = "Number";
  static String yourExpireDate(String documentName) => "Enter your $documentName Expiry Date";
  static String yourDocumentNo(String documentName) => "Enter your $documentName No";

  /// Onboarding Screen
  static const String titleOnboarding = "Become a Rider in 2\nEasy Steps";
  static const String step1Title = "Step 1";
  static const String step1Subtitle = "Work Settings";
  static const String step2Title = "Step 2";
  static const String step2Subtitle = "Profile";

  /// Work Vehicle Screen
  static const String titleSelectVehicle = "Select Vehicle Type";
  static const String msgVehicleRestriction =
      "Your selection will be changed only after 30 days.";
  static const String errorSelectVehicle = "Please select a vehicle type";
  static const String toastSelectedVehicle = "Selected Vehicle:";

  /// Work Document Screen
  static const String titleUploadDocument = "Upload Document";
  static const String msgUploadInstruction = "Upload your documents below";
  static const String docDrivingLicense = "Driving License";
  static const String docPRCard = "PR Card";
  static const String errorCompleteFields = "Please complete all fields";
  static const String docCitizenshipCertificate = "Citizenship Certificate";
  static const String docWorkStudyPermit = "Work / Study Permit";
  static const String docVehicleInsurance = "Vehicle Insurance";

  // Dropdown + Labels
  static const String lblYourStatusInCanada = "Your Status In Canada";
  static const String lblDropdownYourStatus = "Your Status in Canada";

  // Status options
  static const String statusCitizen = "Citizen";
  static const String statusPR = "PR";
  static const String statusTemporaryResidence = "Temporary Residence";

  // Error messages
  static const String errSelectStatus = "Please select your status in Canada";
  static const String errDrivingLicense = "Please upload your Driving License";
  static const String errCitizenshipCertificate =
      "Please upload your Citizenship Certificate";
  static const String errPRCard = "Please upload your PR Card";
  static const String errWorkStudyPermit =
      "Please upload your Work/Study Permit";
  static const String errVehicleInsurance =
      "Please upload your Vehicle Insurance";

  // Document keys
  static const String keyFrontLicense = "front_license";
  static const String keyBackLicense = "back_license";

  static const String keyFrontPR = "front_pr";
  static const String keyBackPR = "back_pr";

  static const String keyFrontCitizen = "front_citizen";
  static const String keyBackCitizen = "back_citizen";

  static const String keyFrontPermit = "front_permit";
  static const String keyBackPermit = "back_permit";

  static const String keyFrontInsurance = "front_insurance";
  static const String keyBackInsurance = "back_insurance";

  /// Work Area Screen
  static const String titleSelectArea = "Select Area";
  static const String msgSelectWorkArea = "Select The Area You Want To Work In";
  static const String labelNearbyZone = "Near By Zone";
  static const String joinBonus = "CAD Joining Bonus";
  static const String weeklyEarnings = "Weekly Earnings";
  static const String upTo = "Up to ";
  static const String kms = "kms";
  static const String errorSelectArea = "Please select an Area";
  static const String toastSelectedArea = "Selected Area:";

  /// Profile Selfie Screen
  static const String btnClickSelfie = "Click A Selfie";
  static const String btnRetakeSelfie = "Retake Selfie";
  static const String titleTakeSelfie = "Take Selfie Photo";
  static const String msgSelfieInstruction =
      "• Ensure that there is a good lighting on your face";
  static const String name = "Name *";
  static const String email = "Email Address *";
  static const String emailAddress = "Email Address ";
  static const String enterYourName = "Enter Your Name";
  static const String nameError = "Please Enter Name";
  static const String validName = "Enter valid Name";
  static const String createYourProfile = "Create Your Profile";
  static const String createProfile = "Create Profile";
  static const String enterYourEmail = "Enter Your Email";
  static const String emailError = "Please Enter Email";

  //Api key
  static const String keyPhoneNumber = 'phoneNumber';
  static const String keyOtp = 'otp';

  // Device types
  static const String deviceTypeAndroid = "android";
  static const String deviceTypeIos = "ios";

  // Social login types
  static const String loginTypePhone = "phone";

  static const String errorInvalidVerificationCode =
      "invalid-verification-code";
  static const String errorSessionExpired = "session-expired";

  /// home screen
  static const String newOrder = "New Order";
  static const String acceptedOrder = "Accepted Order";
  static const String completedOrder = "Completed Order";
  static const String rejectedOrder = "Rejected Order";
  static const String slideChange = "Slide to go ";
  static const String on = "Online";
  static const String off = "Offline";
  static const String underVerification = "Your account is under verification.";
  static const caPricePrefix = "CA\$";
  static const avalBalance = "Available Balance";
  static const zero = "0";
  static const one = "1";
  static const offline = "You are now Offline";
  static const online = "You are now Online";

  // dialog text
  static const String sureLogout = "Sure Log Out?";
  static const String sureDelete = "Sure Delete Account?";
  static const String sureDeleteAddress = "Sure Delete Address?";
  static const String logoutText =
      "Are you sure you want to logout from taber app?";
  static const String deleteText =
      "Are you sure you want to delete account from taber app?";
  static const String deleteAddressText =
      "Are you sure you want to delete Address?";

  /// profile screen
  static const String logOut = "Log Out";
  static const String deleteAccount = "Delete Account";
  static const String privacy = "Privacy";
  static const String helpCenter = "Help Center";
  static const String rating = "Rating";
  static const String bankDetail = "Bank Details";
  static const String withDrawMoney = "Withdraw Money";
  static const String myWallet = "My Wallet";
  static const String taberConnectMobileNo = "Mobile No.";
  static const String joiningDate = "Joining Date";
  static const String city = "City";
  static const String zone = "Zone";
  static const String vehicle = "Vehicle Type";
  static const String updateVehicleType  = "Update Vehicle Type";
  static const String update  = "Update";
  static const String EMAIL = "EMAIL";
  static const String CONTACT = "CONTACT";
  static const String noContact = "No Contact Found";


  // wallet screen
  static const String myWalletSubTitle = "Stay on top of your balance.";
  static const walletFilterAll = "All";
  static const walletFilterIncome = "Credit";
  static const walletFilterExpense = "Debit";
  static const recentTransactions = "Recent Transactions";
  static const walletFilterValueAll = "all";
  static const walletFilterValueIncome = "credit";
  static const walletFilterValueExpense = "debit";
  static const String noTransactionsTitle = "No Transactions Yet";
  static const String noTransactionsContent =
      "Your wallet history will appear here once you start making payments or withdrawals.";
  static const debit = "debit";
  static const payment = "Payment";

  // earning screen
  static const earnings = "Earnings";
  static const earningText = "Earnings";
  static const totalEarning = "Total Earning";
  static const ca = "CA";
  static const String today = "Today";
  static const String thisWeek = "This Week";
  static const String lastWeek = "Last Week";
  static const String thisMonth = "This Month";
  static const String custom = "Custom";
  static const String history = "History";
  static const String addBank = "Add Bank";
  static const String waitForConfirmation =
      "• This may take a moment. Please wait while we confirm your information";
  static const String bankDetailVerification =
      "Your Bank Detail In Verification";
  static const String fewMoreDetailsTitle = "We Need a Few More Details";
  static const String fewMoreDetailsSubtitle =
      "• Almost done! Just share a few more details to continue.";
  static const String todayValue = "today";
  static const String thisWeekValue = "this_week";
  static const String lastWeekValue = "last_week";
  static const String thisMonthValue = "this_month";
  static const String customValue = "custom";
  static const String noEarningsTitle = "No Earnings Yet";
  static const String noEarningsContent =
      "Your earnings will appear here once you start completing orders and receiving payments.";


  // withdrawMoney screen
  static const String availableBalance = "Available balance";
  static const String withDrawMoneySubTitle =
      "Withdraw your money anytime, hassle-free.";
  static const String availableBalanceWithDraw =
      "Available balance to withdraw";
  static const String enterAmount = "Enter Amount";
  static const String proceed = "PROCEED";
  static const String addMoney = "Add Money";

  /// document verification screen
  static const String upload = "Upload";
  static const String uploadImg = "Upload Image";
  static const String verificationFailMsg = "Verification failed! Please complete pending steps.";
  static const String verificationPendingMsg = "Your documents are under verification. We’ll notify you once it’s complete..";

  // bank detail screen
  static const String banks = "Bank";
  static const String bankName = "Bank Name";
  static const String accountHolderName = "Account Holder Name";
  static const String acNumber = "Account Number";
  static const String ifsc = "IFSC Code";

  /// reason for change screen
  static const String changeZone = "Reason To Change Your Zone";
  static const String yourCity = "Select Your City";
  static const String yourZone = "Select Your Zone";
  static const String reasonError = "Please Select any reason";
  static const String zoneError = "Please Select any Zone";
  static const String cityError = "Please Select any City";
  static const String changeCity = "Reason To Change Your City";
  static const String continueText = "Continue";
  static const String reasonShiftingHome = "I am shifting home for some time";
  static const String reasonZoneFar = "Current zone is far from my home";
  static const String reasonAreaUnknown = "I don’t know this area well";
  static const String reasonLowEarnings = "I get low earnings in current zone";
  static const String reasonShiftingHomePermanent =
      "I am shifting home permanently";
  static const String reasonShiftingHomeTemporary =
      "I am shifting home for some time";

  // rating screen
  static const String yourRating = "Your Ratings";

  // order screen
  static const String estimatedEarning  = "Estimated Earnings";
  static const String cancelOrder  = "Cancel Order";
  static const String pickUp  = "Pick Up - ";
  static const String dropOff  = "Drop Off - ";
  static const String pickOrder  = "Pick Order ";
  static const String pickedOrder  = "Picked Order ";
  static const String pickUpText  = "Pick Up";
  static const String dropText  = "Drop";
  static const String reachedDrop  = "Reached Drop";
  static const String reachedPickup  = "Reached Pickup";
  static const String reachedOrder  = "Arrived";
  static const String map  = "Map";
  static const String call  = "Call";
  // reject document screen
  static const typeCitizen = "Citizen";
  static const typePr = "PR";
  static const typeTemporaryResidence = "Temporary Residence";
  static const typeVehicleInsurance = "vehicle_insurance";
  static const typeLic = "license";
  static const typeSelfie = "selfie";
  static const submitToReview = "Submit to Review";
  static const statusPickUp = "picked_up";
  static const statusPending = "pending";
  static const statusAccepted = "accepted";
  static const String leaveAtDoor = "Leave At Door";
  static const String meetAtDoor = "Meet At Door";

  // notification
  static const String noNotifications = "No Notifications";
  static const String notifyWhenUpdate =
      "We’ll let you know when there will\nbe something to update you.";

  // order tracking
  static String restaurantLateBy(int delay) => "Restaurant late by $delay mins";
  static const String checkWithRestaurant = "Check with restaurant if the order is ready";
  static const String orderId = "ORDER ID";
  static const String uploadImgError = "please Capture Photo";
  static const String distance = "Distance";
  static const String duration = "Duration";
  static const String tripEarnings = "Trip Earnings";
  static const String deliveryDone = "Great job! Delivery complete";
  static const String specialInstruction = "Special Instruction";


  // permission strings
  static const String locationPermissionTitle = 'Location Permission Permanently Denied';
  static const String notificationPermissionRequiredTitle = 'Notification Permission Required';
  static const String notificationPermissionNeededTitle = 'Notification Permission Needed';
  static const String locationPermissionMessage =
      'Please enable location permission from settings to continue using the app.';
  static const String notificationPermissionMessage =
      'Please enable notifications from settings to receive important updates.';
  static const String notificationPermissionNeededMessage =
      'Please allow notifications from settings to stay informed about updates.';
  static const String ok = 'Ok';

  // api keys
  static const String keyIsWorkSettingComplete = 'is_worksetting_complete';
  static const String keyIsProfileComplete = 'is_profile_complete';
  static const String keyIsRegisterComplete = 'is_register_complete';
  static const String keyDeliveryBoy = 'delivery_boy';
  static const String keyCity = 'city';
  static const String keyZone = 'zone';
  static const String keyDeliveryDuration = 'delivery_duration';
  static const String cancelled = 'cancelled';
  static const String accepted = 'accepted';
  static const String missed = 'missed';

  // notification key
  static const String keyRiderOpportunity = 'rider_order_opportunity';
  static const String keyOrderCancelled = "order_cancelled";

}
