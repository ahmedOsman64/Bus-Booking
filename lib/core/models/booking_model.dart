enum BookingStatus { pending, confirmed, cancelled }

class Booking {
  final String id;
  final String passengerName;
  final String passengerPhone;
  final String passengerId;
  final String origin;
  final String destination;
  final String travelTime;
  final String travelDate;
  final String busName;
  final List<int> seatNumbers;
  final double totalFare;
  final BookingStatus status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.passengerName,
    required this.passengerPhone,
    required this.passengerId,
    required this.origin,
    required this.destination,
    required this.travelTime,
    required this.travelDate,
    required this.busName,
    required this.seatNumbers,
    required this.totalFare,
    this.status = BookingStatus.pending,
    required this.createdAt,
  });

  Booking copyWith({
    BookingStatus? status,
  }) {
    return Booking(
      id: id,
      passengerName: passengerName,
      passengerPhone: passengerPhone,
      passengerId: passengerId,
      origin: origin,
      destination: destination,
      travelTime: travelTime,
      travelDate: travelDate,
      busName: busName,
      seatNumbers: seatNumbers,
      totalFare: totalFare,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
