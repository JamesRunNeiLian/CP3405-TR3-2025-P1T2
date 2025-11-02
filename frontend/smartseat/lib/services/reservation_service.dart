import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/reservation_model.dart';

class ReservationService {
  final SupabaseClient _supabase = SupabaseService.client;

  /// Get reservations by user ID
  Future<List<ReservationModel>> getReservationsByUser(String userId) async {
    try {
      final response = await _supabase
          .from('reservations')
          .select()
          .eq('user_id', userId)
          .order('reservation_date', ascending: false);

      return (response as List)
          .map((reservation) => ReservationModel.fromMap(reservation))
          .toList();
    } catch (e) {
      print('Error getting user reservations: $e');
      return [];
    }
  }

  /// Get reservations by classroom ID
  Future<List<ReservationModel>> getReservationsByClassroom(String classroomId) async {
    try {
      final response = await _supabase
          .from('reservations')
          .select()
          .eq('classroom_id', classroomId)
          .order('reservation_date', ascending: false);

      return (response as List)
          .map((reservation) => ReservationModel.fromMap(reservation))
          .toList();
    } catch (e) {
      print('Error getting classroom reservations: $e');
      return [];
    }
  }

  /// Create reservation
  Future<String?> createReservation(ReservationModel reservation) async {
    try {
      final data = reservation.toMap();
      data.remove('id');

      final response = await _supabase
          .from('reservations')
          .insert(data)
          .select()
          .single();

      return response['id'] as String;
    } catch (e) {
      print('Error creating reservation: $e');
      return null;
    }
  }

  /// Update reservation
  Future<bool> updateReservation(ReservationModel reservation) async {
    try {
      if (reservation.id == null) return false;

      await _supabase
          .from('reservations')
          .update(reservation.toMap())
          .eq('id', reservation.id!);

      return true;
    } catch (e) {
      print('Error updating reservation: $e');
      return false;
    }
  }

  /// Cancel reservation
  Future<bool> cancelReservation(String id) async {
    try {
      await _supabase
          .from('reservations')
          .update({'status': 'cancelled'})
          .eq('id', id);

      return true;
    } catch (e) {
      print('Error cancelling reservation: $e');
      return false;
    }
  }

  /// Delete reservation
  Future<bool> deleteReservation(String id) async {
    try {
      await _supabase.from('reservations').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting reservation: $e');
      return false;
    }
  }

  /// Get active reservations for a seat
  Future<List<ReservationModel>> getActiveReservationsForSeat(String seatId) async {
    try {
      final now = DateTime.now();
      final response = await _supabase
          .from('reservations')
          .select()
          .eq('seat_id', seatId)
          .eq('status', 'confirmed')
          .gte('reservation_date', now.toIso8601String());

      return (response as List)
          .map((reservation) => ReservationModel.fromMap(reservation))
          .toList();
    } catch (e) {
      print('Error getting active seat reservations: $e');
      return [];
    }
  }
}