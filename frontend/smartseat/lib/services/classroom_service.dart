import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/classroom_model.dart';

class ClassroomService {
  final SupabaseClient _supabase = SupabaseService.client;

  /// Get all classrooms
  Future<List<ClassroomModel>> getAllClassrooms() async {
    try {
      final response = await _supabase
          .from('classrooms')
          .select()
          .order('name');

      return (response as List)
          .map((classroom) => ClassroomModel.fromMap(classroom))
          .toList();
    } catch (e) {
      print('Error getting classrooms: $e');
      return [];
    }
  }

  /// Get classroom by ID
  Future<ClassroomModel?> getClassroom(String id) async {
    try {
      final response = await _supabase
          .from('classrooms')
          .select()
          .eq('id', id)
          .single();

      return ClassroomModel.fromMap(response);
    } catch (e) {
      print('Error getting classroom: $e');
      return null;
    }
  }

  /// Create classroom
  Future<String?> createClassroom(ClassroomModel classroom) async {
    try {
      final data = classroom.toMap();
      data.remove('id'); // Let Supabase generate ID

      final response = await _supabase
          .from('classrooms')
          .insert(data)
          .select()
          .single();

      return response['id'] as String;
    } catch (e) {
      print('Error creating classroom: $e');
      return null;
    }
  }

  /// Update classroom
  Future<bool> updateClassroom(ClassroomModel classroom) async {
    try {
      if (classroom.id == null) return false;

      await _supabase
          .from('classrooms')
          .update(classroom.toMap())
          .eq('id', classroom.id!);

      return true;
    } catch (e) {
      print('Error updating classroom: $e');
      return false;
    }
  }

  /// Delete classroom
  Future<bool> deleteClassroom(String id) async {
    try {
      await _supabase.from('classrooms').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting classroom: $e');
      return false;
    }
  }
}