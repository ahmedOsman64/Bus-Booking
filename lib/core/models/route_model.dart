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
}
