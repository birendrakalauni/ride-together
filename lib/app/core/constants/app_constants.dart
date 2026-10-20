class AppConstants {
  AppConstants._();

  static const String appName = 'rideTogether';

  //Location tracking defaults
  static const double locationDistanceFilterMeters = 25;
  static const int locationUpdateIntervalSeconds = 5;
  //Rider status thresholds
  static const int onlineThresholdSeconds = 30;
  static const int lastSeenThresholdsSeconds = 120;

  static const int heartbeatIntervalSeconds = 20;

  static const int statusRefreshSeconds = 10;
}
