class RideModel {
  final String id; //// ride code, also the DB key
  final String name;
  final String? destination;
  final String createdBy;
  final String status; //waiting/active/ended
  final int createdAt;
  final int? startedAt;
  final int? endedAt;

  RideModel({
    required this.id,
    required this.name,
    this.destination,
    required this.createdBy,
    required this.status,
    required this.createdAt,
    this.startedAt,
    this.endedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'destination': destination,
      'created': createdAt,
      'status': status,
      'createdAt': createdAt,
      'startedAt': startedAt,
      'endedAt': endedAt,
    };
  }

  factory RideModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return RideModel(
      id: id,
      name: map['name'] ?? '',
      destination: map['destination'],
      createdBy: map['createdBy'] ?? '',
      status: map['status'] ?? 'waiting',
      createdAt: map['createdAt'] ?? 0,
      startedAt: map['startedAt'],
      endedAt: map['endedAt'],
    );
  }
}
