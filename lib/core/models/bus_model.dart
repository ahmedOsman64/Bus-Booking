class Bus {
  final String id;
  final String number;
  final String plateNumber;
  final int totalSeats;
  final List<int> occupiedSeats;
  final String type; // e.g., 'Luxury', 'Standard'
  final String status; // e.g., 'Available', 'On Trip', 'Maintenance'

  Bus({
    required this.id,
    required this.number,
    required this.plateNumber,
    required this.totalSeats,
    this.occupiedSeats = const [],
    required this.type,
    required this.status,
  });

  Bus copyWith({
    String? id,
    String? number,
    String? plateNumber,
    int? totalSeats,
    List<int>? occupiedSeats,
    String? type,
    String? status,
  }) {
    return Bus(
      id: id ?? this.id,
      number: number ?? this.number,
      plateNumber: plateNumber ?? this.plateNumber,
      totalSeats: totalSeats ?? this.totalSeats,
      occupiedSeats: occupiedSeats ?? this.occupiedSeats,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}
