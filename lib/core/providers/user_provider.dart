import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super(_initialUsers);

  static final List<User> _initialUsers = [
    User(
      id: '1',
      firstName: 'Ahmed',
      lastName: 'Hassan',
      email: 'ahmed@somsafar.com',
      phoneNumber: '+252 615123456',
      role: UserRole.admin,
      status: UserStatus.active,
      lastActive: '2 hours ago',
      adminCategory: 'Super Admin',
    ),
    User(
      id: '2',
      firstName: 'Mohamed',
      lastName: 'Ali',
      email: 'mohamed@example.com',
      phoneNumber: '+252 615654321',
      role: UserRole.driver,
      status: UserStatus.active,
      lastActive: '1 day ago',
    ),
    User(
      id: '3',
      firstName: 'Fartun',
      lastName: 'Osman',
      email: 'fartun@example.com',
      phoneNumber: '+252 615998877',
      role: UserRole.passenger,
      status: UserStatus.active,
      lastActive: '5 mins ago',
    ),
  ];

  void addUser(User user) {
    state = [...state, user];
  }

  void updateUser(User updatedUser) {
    state = [
      for (final user in state)
        if (user.id == updatedUser.id) updatedUser else user
    ];
  }

  void deleteUser(String id) {
    state = state.where((user) => user.id != id).toList();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});
