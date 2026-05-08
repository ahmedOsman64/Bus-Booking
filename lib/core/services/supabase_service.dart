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
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  // Database methods example
  static Future<List<Map<String, dynamic>>> getBuses() async {
    final response = await client.from('buses').select();
    return response;
  }
}
