import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route_model.dart';

class RouteNotifier extends StateNotifier<List<BusRoute>> {
  RouteNotifier() : super(_dummyRoutes);

  void addRoute(BusRoute route) {
    state = [...state, route];
  }

  void updateRoute(BusRoute updatedRoute) {
    state = [
      for (final route in state)
        if (route.id == updatedRoute.id) updatedRoute else route
    ];
  }

  void deleteRoute(String id) {
    state = state.where((route) => route.id != id).toList();
  }

  static final List<BusRoute> _dummyRoutes = [
    BusRoute(
      id: 'R001',
      origin: 'Mogadishu',
      destination: 'Afgooye',
      departureTime: '08:00 AM',
      arrivalTime: '09:30 AM',
      price: 15.0,
      busId: 'B001',
    ),
    BusRoute(
      id: 'R002',
      origin: 'Mogadishu',
      destination: 'Kismayo',
      departureTime: '06:00 AM',
      arrivalTime: '04:00 PM',
      price: 25.0,
      busId: 'B002',
    ),
    BusRoute(
      id: 'R003',
      origin: 'Mogadishu',
      destination: 'Baidoa',
      departureTime: '07:30 AM',
      arrivalTime: '01:30 PM',
      price: 20.0,
      busId: 'B003',
    ),
  ];
}

final routeProvider = StateNotifierProvider<RouteNotifier, List<BusRoute>>((ref) {
  return RouteNotifier();
});
