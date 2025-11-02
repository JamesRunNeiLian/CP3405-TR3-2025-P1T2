import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseService.client;

  /// Sign in with email and password
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password)
          .maybeSingle();

      if (response != null) {
        return response as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  /// Register a new user
  Future<bool> register(UserModel user) async {
    try {
      final data = user.toMap();
      data.remove('id');
      
      await _supabase.from('users').insert(data);
      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', id)
          .single();

      if (response != null) {
        return UserModel.fromMap(response);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Update user
  Future<bool> updateUser(UserModel user) async {
    try {
      if (user.id == null) return false;

      await _supabase
          .from('users')
          .update(user.toMap())
          .eq('id', user.id!);

      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  /// Delete user
  Future<bool> deleteUser(String id) async {
    try {
      await _supabase.from('users').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  /// Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _supabase.from('users').select();
      return (response as List)
          .map((user) => UserModel.fromMap(user))
          .toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  /// Sign out
  Future<void> signOut() async {
    // Add any cleanup logic here if needed
  }
}