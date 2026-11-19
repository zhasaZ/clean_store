class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://fakestoreapi.com';
  static const String products = '/products';
  static const Duration timeout = Duration(seconds: 15);
}

class StorageKeys {
  StorageKeys._();

  static const String favorites = 'favorite_products';
}
