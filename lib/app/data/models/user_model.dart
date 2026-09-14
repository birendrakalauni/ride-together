class UserModel {
  final String id;
  final String name;
  final String email;
  final int createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'createdAt': createdAt};
  }

  factory UserModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt'] ?? 0,
    );
  }
}
