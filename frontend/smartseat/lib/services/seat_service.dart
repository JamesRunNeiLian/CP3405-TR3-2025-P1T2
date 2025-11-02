import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/seat_model.dart';

class SeatService {
  final SupabaseClient _supabase = SupabaseService.client;

  /// Get seats by classroom ID
  Future<List<SeatModel>> getSeatsByClassroom(String classroomId) async {
    try {
      final response = await _supabase
          .from('seats')
          .select()
          .eq('classroom_id', classroomId)
          .order('row_number')
          .order('column_number');

      return (response as List)
          .map((seat) => SeatModel.fromMap(seat))
          .toList();
    } catch (e) {
      print('Error getting seats: $e');
      return [];
    }
  }

  /// Get available seats by classroom ID
  Future<List<SeatModel>> getAvailableSeats(String classroomId) async {
    try {
      final response = await _supabase
          .from('seats')
          .select()
          .eq('classroom_id', classroomId)
          .eq('is_available', true)
          .order('row_number')
          .order('column_number');

      return (response as List)
          .map((seat) => SeatModel.fromMap(seat))
          .toList();
    } catch (e) {
      print('Error getting available seats: $e');
      return [];
    }
  }

  /// Create seat
  Future<String?> createSeat(SeatModel seat) async {
    try {
      final data = seat.toMap();
      data.remove('id');

      final response = await _supabase
          .from('seats')
          .insert(data)
          .select()
          .single();

      return response['id'] as String;
    } catch (e) {
      print('Error creating seat: $e');
      return null;
    }
  }

  /// Update seat
  Future<bool> updateSeat(SeatModel seat) async {
    try {
      if (seat.id == null) return false;

      await _supabase
          .from('seats')
          .update(seat.toMap())
          .eq('id', seat.id!);

      return true;
    } catch (e) {
      print('Error updating seat: $e');
      return false;
    }
  }

  /// Delete seat
  Future<bool> deleteSeat(String id) async {
    try {
      await _supabase.from('seats').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting seat: $e');
      return false;
    }
  }

  /// Toggle seat availability
  Future<bool> toggleSeatAvailability(String id, bool isAvailable) async {
    try {
      await _supabase
          .from('seats')
          .update({'is_available': isAvailable})
          .eq('id', id);

      return true;
    } catch (e) {
      print('Error toggling seat availability: $e');
      return false;
    }
  }
}