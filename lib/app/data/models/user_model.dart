class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final int createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
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
      profileImage: map['profileImage'],
      createdAt: map['createdAt'] ?? 0,
    );
  }
}
