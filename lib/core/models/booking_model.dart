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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passenger_name': passengerName,
      'passenger_phone': passengerPhone,
      'passenger_id': passengerId,
      'seat_numbers': seatNumbers,
      'total_fare': totalFare,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      passengerName: map['passenger_name'] ?? '',
      passengerPhone: map['passenger_phone'] ?? '',
      passengerId: map['passenger_id'] ?? '',
      origin: '', // These would come from trip join
      destination: '',
      travelTime: '',
      travelDate: '',
      busName: '',
      seatNumbers: List<int>.from(map['seat_numbers'] ?? []),
      totalFare: (map['total_fare'] ?? 0.0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == (map['status'] ?? 'pending'),
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
