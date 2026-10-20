class AppDateUtils {
  AppDateUtils._();

  static String lastSeen(int seconds) {
    if (seconds < 60) return '${seconds}s ago';
    if (seconds < 3600) return '${seconds ~/ 60} min ago';
    if (seconds < 86400) return '${seconds ~/ 3600} h ago';
    return '${seconds ~/ 86400} d ago';
  }
}
