import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role'; // 'admin' or 'user'

  /// Saves login session to SharedPreferences
  static Future<void> saveSession({
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserRole, role);
  }

  /// Returns true if a session exists (user was previously logged in)
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Returns the saved user role: 'admin' or 'user'
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  /// Returns the saved user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  /// Clears the session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
