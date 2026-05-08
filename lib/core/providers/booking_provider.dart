import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';

import '../services/supabase_service.dart';

class BookingNotifier extends StateNotifier<List<Booking>> {
  BookingNotifier() : super([]) {
    fetchBookings();
  }

  Future<void> fetchBookings({int page = 0, int pageSize = 20}) async {
    if (!SupabaseService.isInitialized) return;
    try {
      final from = page * pageSize;
      final to = from + pageSize - 1;

      final List<dynamic> data = await SupabaseService.client
          .from('bookings')
          .select()
          .order('created_at', ascending: false)
          .range(from, to);
      
      final newBookings = data.map((e) => Booking.fromMap(e)).toList();
      if (page == 0) {
        state = newBookings;
      } else {
        state = [...state, ...newBookings];
      }
    } catch (e) {
      // debugPrint('Error fetching bookings: $e');
    }
  }

  Future<void> addBooking(Booking booking) async {
    try {
      await SupabaseService.client.from('bookings').insert(booking.toMap());
      state = [...state, booking];
    } catch (e) {
      // debugPrint('Error adding booking: $e');
    }
  }

  Future<void> updateBookingStatus(String id, BookingStatus status) async {
    try {
      await SupabaseService.client
          .from('bookings')
          .update({'status': status.name}).eq('id', id);
      state = [
        for (final booking in state)
          if (booking.id == id) booking.copyWith(status: status) else booking,
      ];
    } catch (e) {
      // debugPrint('Error updating booking status: $e');
    }
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, List<Booking>>((ref) {
  return BookingNotifier();
});
