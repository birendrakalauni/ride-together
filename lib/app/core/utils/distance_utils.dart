class DistanceUtils {
  DistanceUtils._();

  static String formatDistance(double meters) {
    if (meters < 1000) {
      final rounded = (meters / 10).round() * 10;
      return '$rounded m';
    }

    final km = meters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }
}
