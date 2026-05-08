import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bus_model.dart';

class BusNotifier extends StateNotifier<List<Bus>> {
  BusNotifier() : super(_initialBuses);

  static final List<Bus> _initialBuses = [
    Bus(id: 'B101', number: 'BUS-101', plateNumber: 'SOM-1000', totalSeats: 45, type: 'Luxury', status: 'Available'),
    Bus(id: 'B102', number: 'BUS-102', plateNumber: 'SOM-1007', totalSeats: 45, type: 'Standard', status: 'On Trip'),
    Bus(id: 'B103', number: 'BUS-103', plateNumber: 'SOM-1014', totalSeats: 30, type: 'Economy', status: 'Maintenance'),
    Bus(id: 'B104', number: 'BUS-104', plateNumber: 'SOM-1021', totalSeats: 45, type: 'Luxury', status: 'Available'),
  ];

  void addBus(Bus bus) {
    state = [...state, bus];
  }

  void updateBus(Bus updatedBus) {
    state = [
      for (final bus in state)
        if (bus.id == updatedBus.id) updatedBus else bus,
    ];
  }

  void removeBus(String id) {
    state = state.where((bus) => bus.id != id).toList();
  }

  void updateBusStatus(String id, String status) {
    state = [
      for (final bus in state)
        if (bus.id == id) bus.copyWith(status: status) else bus,
    ];
  }
}

final busProvider = StateNotifierProvider<BusNotifier, List<Bus>>((ref) {
  return BusNotifier();
});
