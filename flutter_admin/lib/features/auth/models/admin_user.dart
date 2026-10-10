class AdminUser {
  AdminUser({
    required this.email,
    required this.name,
    required this.role,
    required this.token,
  });

  final String email;
  final String name;
  final String role;
  final String token;

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
    );
  }
}
