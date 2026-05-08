
enum UserRole { passenger, driver, admin }
enum UserStatus { active, inactive }

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final UserRole role;
  final UserStatus status;
  final String lastActive;
  final String? adminCategory;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.status,
    required this.lastActive,
    this.adminCategory,
  });

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    UserRole? role,
    UserStatus? status,
    String? lastActive,
    String? adminCategory,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      status: status ?? this.status,
      lastActive: lastActive ?? this.lastActive,
      adminCategory: adminCategory ?? this.adminCategory,
    );
  }
}
