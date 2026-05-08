import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (supabaseUrl == 'YOUR_SUPABASE_URL' || supabaseAnonKey == 'YOUR_SUPABASE_ANON_KEY') {
      debugPrint('Supabase credentials are not set. Skipping initialization.');
      return;
    }
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint('Supabase Init Error: $e');
    }
  }

  static SupabaseClient get client {
    if (!_isInitialized) {
      throw StateError('Supabase is not initialized. Please check your credentials.');
    }
    return Supabase.instance.client;
  }

  static bool get isInitialized => _isInitialized;

  // Authentication methods
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      debugPrint('SignOut Error: $e');
    }
  }

  static Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Database methods example
  static Future<List<Map<String, dynamic>>> getBuses() async {
    try {
      final response = await client.from('buses').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Database Error (getBuses): $e');
      throw Exception('Failed to fetch buses. Please check your connection.');
    }
  }

  static String _handleAuthError(dynamic e) {
    if (e is AuthException) {
      return e.message;
    }
    return e.toString();
  }
}
