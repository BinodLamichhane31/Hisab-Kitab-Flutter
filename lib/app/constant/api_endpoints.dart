class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://localhost:6060";

  static const String baseUrl = "$serverAddress/api";
  static const String imageUrl = "$serverAddress/uploads";

  //Auth
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String profile = "/auth/profile";
  static const String logout = "/auth/logout";

  //SHOP
  static const String shops = "/shops";
  static const String shopById = "/shops/";
  static const String switchShop = "/shops/select-shop";

  //Customers
  static const String customers = '/customers';
  static const String customerById = '/customers/';
}
