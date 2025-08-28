class AppConstants {
  // App Info
  static const String appName = 'Meetup 237';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Modern African Dating App';
  
  // API Configuration
  static const String supabaseUrl = 'https://cntvamovncufkngcbdcm.supabase.co';
  static const String apiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNudHZhbW92bmN1ZmtuZ2NiZGNtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzMDg4NTUsImV4cCI6MjA3MTg4NDg1NX0.Jv-tswoEG4w6aw80zB6-8X09NjK1_oKd-KL_RTwBhvk';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String onboardingKey = 'onboarding_completed';
  
  // Image Configuration
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const double maxImageWidth = 1080.0;
  static const double maxImageHeight = 1080.0;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minAge = 18;
  static const int maxAge = 100;
  static const double maxSearchDistance = 100.0; // km
  
  // Social Media
  static const String facebookUrl = 'https://facebook.com/afromeet';
  static const String twitterUrl = 'https://twitter.com/afromeet';
  static const String instagramUrl = 'https://instagram.com/afromeet';
  static const String supportEmail = 'support@afromeet.com';
  
  // Legal
  static const String privacyPolicyUrl = 'https://afromeet.com/privacy';
  static const String termsOfServiceUrl = 'https://afromeet.com/terms';
  
  // Firebase
  static const String firebaseMessagingTopic = 'all_users';
  
  // Socket Events
  static const String socketConnect = 'connect';
  static const String socketDisconnect = 'disconnect';
  static const String socketJoinRoom = 'join_room';
  static const String socketLeaveRoom = 'leave_room';
  static const String socketNewMessage = 'new_message';
  static const String socketMessageRead = 'message_read';
  static const String socketUserTyping = 'user_typing';
  static const String socketUserStoppedTyping = 'user_stopped_typing';
  static const String socketUserOnline = 'user_online';
  static const String socketUserOffline = 'user_offline';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  
  // Debounce Durations
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration typingDebounce = Duration(milliseconds: 1000);
  
  // Cache Durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(minutes: 30);
  static const Duration longCacheDuration = Duration(hours: 24);
}
