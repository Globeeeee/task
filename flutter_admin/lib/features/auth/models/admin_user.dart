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

  factory AdminUser.fromJson(Map<String, dynamic> j) => AdminUser(
        email: j['email']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
        role: j['role']?.toString() ?? '',
        token: j['token']?.toString() ?? '',
      );
}
