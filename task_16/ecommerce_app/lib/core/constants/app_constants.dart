class AppConstants {
  // API Configuration
  static const String baseUrl =
      'https://g5-flutter-learning-path-be.onrender.com/';
  static const String apiVersion = 'v1';

  // HTTP Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Error Messages
  static const String networkErrorMessage = 'No internet connection available';
  static const String serverErrorMessage =
      'Server error occurred. Please try again later.';
  static const String cacheErrorMessage = 'Failed to load cached data';
  static const String generalErrorMessage =
      'Something went wrong. Please try again.';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 8.0;
  static const double defaultElevation = 2.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Cache Keys
  static const String productsCacheKey = 'products_cache';
  static const String productCacheKey = 'product_cache';

  // Validation Messages
  static const String requiredFieldMessage = 'This field is required';
  static const String invalidEmailMessage = 'Please enter a valid email';
  static const String invalidPriceMessage = 'Please enter a valid price';
  static const String invalidUrlMessage = 'Please enter a valid URL';
}
