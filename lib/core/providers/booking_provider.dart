import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';

class BookingNotifier extends StateNotifier<List<Booking>> {
  BookingNotifier() : super(_dummyBookings);

  void addBooking(Booking booking) {
    state = [...state, booking];
  }

  void updateBookingStatus(String id, BookingStatus status) {
    state = [
      for (final booking in state)
        if (booking.id == id) booking.copyWith(status: status) else booking,
    ];
  }

  static final List<Booking> _dummyBookings = [
    Booking(
      id: 'BKN-2026001',
      passengerName: 'Ahmed Osman',
      passengerPhone: '615555555',
      passengerId: 'ID12345',
      origin: 'Mogadishu',
      destination: 'Afgooye',
      travelTime: '08:00 AM',
      travelDate: 'May 10, 2026',
      busName: 'Express 01',
      seatNumbers: [5, 6],
      totalFare: 30.0,
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    ),
    Booking(
      id: 'BKN-2026002',
      passengerName: 'Fatima Ali',
      passengerPhone: '616666666',
      passengerId: 'ID67890',
      origin: 'Mogadishu',
      destination: 'Kismayo',
      travelTime: '10:00 AM',
      travelDate: 'May 11, 2026',
      busName: 'Sahal Luxury',
      seatNumbers: [12],
      totalFare: 25.0,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    ),
  ];
}

final bookingProvider = StateNotifierProvider<BookingNotifier, List<Booking>>((ref) {
  return BookingNotifier();
});
