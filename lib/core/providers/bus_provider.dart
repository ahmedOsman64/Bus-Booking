import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bus_model.dart';

import '../services/supabase_service.dart';

class BusNotifier extends StateNotifier<List<Bus>> {
  BusNotifier() : super([]) {
    fetchBuses();
  }

  Future<void> fetchBuses() async {
    if (!SupabaseService.isInitialized) return;
    try {
      final List<dynamic> data = await SupabaseService.client.from('buses').select();
      state = data.map((e) => Bus.fromMap(e)).toList();
    } catch (e) {
      // debugPrint('Error fetching buses: $e');
    }
  }

  Future<void> addBus(Bus bus) async {
    try {
      await SupabaseService.client.from('buses').insert(bus.toMap());
      state = [...state, bus];
    } catch (e) {
      // debugPrint('Error adding bus: $e');
    }
  }

  Future<void> updateBus(Bus updatedBus) async {
    try {
      await SupabaseService.client
          .from('buses')
          .update(updatedBus.toMap())
          .eq('id', updatedBus.id);
      state = [
        for (final bus in state)
          if (bus.id == updatedBus.id) updatedBus else bus,
      ];
    } catch (e) {
      // debugPrint('Error updating bus: $e');
    }
  }

  Future<void> removeBus(String id) async {
    try {
      await SupabaseService.client.from('buses').delete().eq('id', id);
      state = state.where((bus) => bus.id != id).toList();
    } catch (e) {
      // debugPrint('Error removing bus: $e');
    }
  }

  Future<void> updateBusStatus(String id, String status) async {
    try {
      await SupabaseService.client
          .from('buses')
          .update({'status': status}).eq('id', id);
      state = [
        for (final bus in state)
          if (bus.id == id) bus.copyWith(status: status) else bus,
      ];
    } catch (e) {
      // debugPrint('Error updating bus status: $e');
    }
  }
}

final busProvider = StateNotifierProvider<BusNotifier, List<Bus>>((ref) {
  return BusNotifier();
});
