
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
  final String? profileImage;

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
    this.profileImage,
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
    String? profileImage,
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
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role.name,
      'status': status.name,
      'admin_category': adminCategory,
      'profile_image': profileImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == (map['role'] ?? 'passenger'),
        orElse: () => UserRole.passenger,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'active'),
        orElse: () => UserStatus.active,
      ),
      lastActive: map['last_active']?.toString() ?? 'unknown',
      adminCategory: map['admin_category'],
      profileImage: map['profile_image'],
    );
  }
}
