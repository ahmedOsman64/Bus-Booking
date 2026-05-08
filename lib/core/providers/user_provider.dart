import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

import '../services/supabase_service.dart';

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super([]) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final List<dynamic> data = await SupabaseService.client.from('profiles').select();
      state = data.map((e) => User.fromMap(e)).toList();
    } catch (e) {
      // debugPrint('Error fetching users: $e');
    }
  }

  Future<void> addUser(User user) async {
    try {
      await SupabaseService.client.from('profiles').insert(user.toMap());
      state = [...state, user];
    } catch (e) {
      // debugPrint('Error adding user: $e');
    }
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      await SupabaseService.client
          .from('profiles')
          .update(updatedUser.toMap())
          .eq('id', updatedUser.id);
      state = [
        for (final user in state)
          if (user.id == updatedUser.id) updatedUser else user
      ];
    } catch (e) {
      // debugPrint('Error updating user: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await SupabaseService.client.from('profiles').delete().eq('id', id);
      state = state.where((user) => user.id != id).toList();
    } catch (e) {
      // debugPrint('Error deleting user: $e');
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});
