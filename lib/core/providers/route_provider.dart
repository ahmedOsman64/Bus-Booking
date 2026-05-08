import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/route_model.dart';

import '../services/supabase_service.dart';

class RouteNotifier extends StateNotifier<List<BusRoute>> {
  RouteNotifier() : super([]) {
    fetchRoutes();
  }

  Future<void> fetchRoutes() async {
    if (!SupabaseService.isInitialized) return;
    try {
      final List<dynamic> data = await SupabaseService.client.from('routes').select();
      state = data.map((e) => BusRoute.fromMap(e)).toList();
    } catch (e) {
      // debugPrint('Error fetching routes: $e');
    }
  }

  Future<void> addRoute(BusRoute route) async {
    try {
      await SupabaseService.client.from('routes').insert(route.toMap());
      state = [...state, route];
    } catch (e) {
      // debugPrint('Error adding route: $e');
    }
  }

  Future<void> updateRoute(BusRoute updatedRoute) async {
    try {
      await SupabaseService.client
          .from('routes')
          .update(updatedRoute.toMap())
          .eq('id', updatedRoute.id);
      state = [
        for (final route in state)
          if (route.id == updatedRoute.id) updatedRoute else route
      ];
    } catch (e) {
      // debugPrint('Error updating route: $e');
    }
  }

  Future<void> deleteRoute(String id) async {
    try {
      await SupabaseService.client.from('routes').delete().eq('id', id);
      state = state.where((route) => route.id != id).toList();
    } catch (e) {
      // debugPrint('Error deleting route: $e');
    }
  }
}

final routeProvider = StateNotifierProvider<RouteNotifier, List<BusRoute>>((ref) {
  return RouteNotifier();
});
