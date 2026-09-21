class RideMemberModel {
  final String userId;
  final String name;
  final String role; //leader | member
  final int joinedAt;

  RideMemberModel({
    required this.userId,
    required this.name,
    required this.role,
    required this.joinedAt,
  });

  factory RideMemberModel.fromMap(String userId, Map<dynamic, dynamic> map) {
    return RideMemberModel(
      userId: userId,
      name: map['name'] ?? 'Rider',
      role: map['role'] ?? 'member',
      joinedAt: map['joinedAt'] ?? 0,
    );
  }
}
