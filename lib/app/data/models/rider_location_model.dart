class RiderLocationModel {
  final String userId;
  final double latitude;
  final double longitude;
  final double accuracy;
  final double speed;
  final double heading;
  final int updatedAt;

  RiderLocationModel({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.speed,
    required this.heading,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'speed': speed,
      'heading': heading,
      'updatedAt': updatedAt,
    };
  }

  factory RiderLocationModel.fromMap(Map<dynamic, dynamic> map) {
    return RiderLocationModel(
      userId: map['userId'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      accuracy: (map['accuracy'] ?? 0).toDouble(),
      speed: (map['speed'] ?? 0).toDouble(),
      heading: (map['heading'] ?? 0).toDouble(),
      updatedAt: map['updatedAt'] ?? 0,
    );
  }

  int get secondsSinceUpdate =>
      ((DateTime.now().microsecondsSinceEpoch - updatedAt) / 1000).round();
}
