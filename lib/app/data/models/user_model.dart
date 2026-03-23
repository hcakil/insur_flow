class UserModel {
  final String id;
  final String fullName;
  final String email;
  /// Örn: Admin, User
  final String role;
  /// Örn: Aktif, Pasif
  final String status;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
  });
}
