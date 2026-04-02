class ApiConstants {
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const String apiVersion = 'v1';
  
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefresh = '/auth/refresh';
  static const String authOtpSend = '/auth/otp/send';
  static const String authOtpVerify = '/auth/otp/verify';
  
  static const String usersMe = '/users/me';
  static const String usersAddresses = '/users/addresses';
  
  static const String books = '/books';
  static const String booksSearch = '/books/search';
  static const String booksRecommendations = '/books/recommendations';
  
  static const String categoriesBoards = '/categories/boards';
  static const String categoriesGrades = '/categories/grades';
  static const String categoriesSubjects = '/categories/subjects';
  
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';
  static const String wishlist = '/wishlist';
  
  static const String orders = '/orders';
  static const String couponsValidate = '/coupons/validate';
  
  static const String paymentsCreateOrder = '/payments/create-order';
  static const String paymentsVerify = '/payments/verify';
  
  static const String vendorsRegister = '/vendors/register';
  static const String vendorsDashboard = '/vendors/dashboard';
  static const String vendorsInventory = '/vendors/inventory';
  static const String vendorsOrders = '/vendors/orders';
  
  static const String adminDashboard = '/admin/dashboard';
  static const String adminVendors = '/admin/vendors';
  static const String adminBooks = '/admin/books';
  static const String adminCategories = '/admin/categories';
  static const String adminUsers = '/admin/users';
  static const String adminOrders = '/admin/orders';
  static const String adminAnalytics = '/admin/analytics';
}

class AppConstants {
  static const String appName = 'SchoolBooks';
  static const String appTagline = 'Your Learning Partner';
  
  static const List<String> supportedLocales = ['en', 'hi'];
  static const String defaultLocale = 'en';
  
  static const List<String> boards = ['CBSE', 'ICSE', 'State Board'];
  static const List<String> grades = [
    'Nursery', 'LKG', 'UKG',
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
    'Class 11', 'Class 12'
  ];
  
  static const List<String> subjects = [
    'Mathematics', 'Science', 'English', 'Hindi', 'Social Studies',
    'Physics', 'Chemistry', 'Biology', 'History', 'Geography',
    'Economics', 'Accountancy', 'Business Studies', 'Computer Science',
    'Environmental Studies', 'Sanskrit', 'Physical Education'
  ];
  
  static const List<String> stateBoards = [
    'Andhra Pradesh', 'Bihar', 'Gujarat', 'Karnataka', 'Kerala',
    'Madhya Pradesh', 'Maharashtra', 'Punjab', 'Rajasthan',
    'Tamil Nadu', 'Telangana', 'Uttar Pradesh', 'West Bengal'
  ];
}

class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String user = 'user';
  static const String userRole = 'user_role';
  static const String theme = 'theme';
  static const String locale = 'locale';
  static const String onboarding = 'onboarding';
  static const String cartItems = 'cart_items';
  static const String wishlistItems = 'wishlist_items';
}
