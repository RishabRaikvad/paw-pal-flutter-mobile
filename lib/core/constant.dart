enum Gender { male, female }

enum HavePet { yes, no }
enum VariantType { weight, size, none }


class Constant {
  static String razorPayKey = "razorpayKey";
  static String stateWiseCityApiKey = "stateWiseCityApiKey";
  static const String fontFamily = "Outfit";
  static const int staticCount = 6;

  // api url
  static final String stateWiseCityApi =
      "https://api.countrystatecity.in/v1/countries/IN/states";
}
