class BusRoute {
  final String id;
  final String origin;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final double price;
  final String busId;

  BusRoute({
    required this.id,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.busId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'origin': origin,
      'destination': destination,
      'base_price': price,
    };
  }

  factory BusRoute.fromMap(Map<String, dynamic> map) {
    return BusRoute(
      id: map['id'] ?? '',
      origin: map['origin'] ?? '',
      destination: map['destination'] ?? '',
      departureTime: '', // These would come from trips in the real DB
      arrivalTime: '',
      price: (map['base_price'] ?? 0.0).toDouble(),
      busId: '',
    );
  }
}
