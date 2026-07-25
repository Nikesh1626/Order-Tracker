import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/api_service.dart';

// Providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ForceErrorNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool val) => state = val;
}
final forceErrorProvider = NotifierProvider<ForceErrorNotifier, bool>(ForceErrorNotifier.new);

class OrderState {
  final bool isLoading;
  final List<Order> orders;
  final String? error;
  final bool isOffline;

  OrderState({
    this.isLoading = false,
    this.orders = const [],
    this.error,
    this.isOffline = false,
  });

  OrderState copyWith({
    bool? isLoading,
    List<Order>? orders,
    String? error,
    bool? isOffline,
    bool clearError = false,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      error: clearError ? null : (error ?? this.error),
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class OrderNotifier extends Notifier<OrderState> {
  @override
  OrderState build() {
    final sub = Connectivity().onConnectivityChanged.listen((results) {
      final isOffline = results.contains(ConnectivityResult.none);
      
      if (state.isOffline && !isOffline && state.orders.isEmpty) {
        // Just came back online and we don't have orders, fetch them
        fetchOrders();
      }
      
      state = state.copyWith(isOffline: isOffline);
    });

    ref.onDispose(() => sub.cancel());

    Future.microtask(() => fetchOrders());
    return OrderState(isLoading: true);
  }

  Future<void> fetchOrders() async {
    if (state.isLoading && state.orders.isEmpty) {
      // Already loading initial data
    } else {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final apiService = ref.read(apiServiceProvider);
      // Check if force error is enabled
      final forceError = ref.read(forceErrorProvider);
      if (forceError) {
        await Future.delayed(const Duration(milliseconds: 500));
        throw Exception('Forced error for demo purposes');
      }

      final orders = await apiService.fetchOrders();
      state = state.copyWith(
        isLoading: false,
        orders: orders,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final orderProvider = NotifierProvider<OrderNotifier, OrderState>(OrderNotifier.new);
