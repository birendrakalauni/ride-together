import 'package:flutter/material.dart';
import 'package:ride_together/app/core/constants/app_constants.dart';

enum RiderStatus { online, weakConnection, offline }

class RiderStatusUtils {
  RiderStatusUtils._();

  static RiderStatus fromSecondsSinceUpdate(int seconds) {
    if (seconds < AppConstants.onlineThresholdSeconds) {
      return RiderStatus.online;
    }
    if (seconds <= AppConstants.lastSeenThresholdsSeconds) {
      return RiderStatus.weakConnection;
    }
    return RiderStatus.offline;
  }
}

extension RiderStatusColor on RiderStatus {
  Color get color {
    switch (this) {
      case RiderStatus.online:
        return Colors.green;

      case RiderStatus.weakConnection:
        return Colors.orange;

      case RiderStatus.offline:
        return Colors.red;
    }
  }
}
