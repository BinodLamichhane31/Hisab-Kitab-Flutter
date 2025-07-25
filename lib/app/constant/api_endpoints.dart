class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://localhost:6060";

  static const String baseUrl = "$serverAddress/api";

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
  static String customerById(String customerId) => '/customers/$customerId';

  //Suppliers
  static const String suppliers = '/suppliers';
  static String supplierById(String supplierId) => '/suppliers/$supplierId';

  //Products
  static const String products = '$baseUrl/products';
  static String productById(String productId) => '$baseUrl/products/$productId';

  //sale
  static const String sales = '$baseUrl/sales';
  static String saleById(String id) => '$baseUrl/sales/$id';

  //purchase
  static const String purchases = '$baseUrl/purchases';
  static String purchaseById(String id) => '$baseUrl/purchases/$id';

  //transactions
  static const String transactions = '$baseUrl/transactions';
}
