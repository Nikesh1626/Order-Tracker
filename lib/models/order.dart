import 'package:flutter/material.dart';

enum OrderStatus {
  placed,
  packed,
  shipped,
  outForDelivery,
  delivered,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get chipBgColor {
    switch (this) {
      case OrderStatus.placed: return const Color(0xFFE3F2FD);
      case OrderStatus.packed: return const Color(0xFFFFF3E0);
      case OrderStatus.shipped: return const Color(0xFFF3E5F5);
      case OrderStatus.outForDelivery: return const Color(0xFFE0F7FA); // Teal background
      case OrderStatus.delivered: return const Color(0xFFE8F5E9);
      case OrderStatus.cancelled: return const Color(0xFFFFEBEE);
    }
  }

  Color get textColor {
    switch (this) {
      case OrderStatus.placed: return const Color(0xFF1976D2);
      case OrderStatus.packed: return const Color(0xFFF57C00);
      case OrderStatus.shipped: return const Color(0xFF7B1FA2);
      case OrderStatus.outForDelivery: return const Color(0xFF00838F); // Teal text
      case OrderStatus.delivered: return const Color(0xFF388E3C);
      case OrderStatus.cancelled: return const Color(0xFFD32F2F);
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatus.placed: return Icons.receipt_long_outlined;
      case OrderStatus.packed: return Icons.inventory_2_outlined;
      case OrderStatus.shipped: return Icons.flight_takeoff_outlined;
      case OrderStatus.outForDelivery: return Icons.local_shipping_outlined;
      case OrderStatus.delivered: return Icons.check_circle_outline;
      case OrderStatus.cancelled: return Icons.cancel_outlined;
    }
  }
}

class OrderStatusHistory {
  final OrderStatus status;
  final DateTime timestamp;

  OrderStatusHistory({
    required this.status,
    required this.timestamp,
  });

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) {
    return OrderStatusHistory(
      status: _parseStatus(json['status'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'status': status.displayName,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }
}

class Order {
  final String id;
  final String customer;
  final List<String> items;
  final double amount;
  final OrderStatus status;
  final DateTime placedAt;
  final List<OrderStatusHistory> statusHistory;

  Order({
    required this.id,
    required this.customer,
    required this.items,
    required this.amount,
    required this.status,
    required this.placedAt,
    required this.statusHistory,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customer: json['customer'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
      amount: (json['amount'] as num).toDouble(),
      status: _parseStatus(json['status'] as String),
      placedAt: DateTime.parse(json['placed_at'] as String),
      statusHistory: (json['status_history'] as List<dynamic>?)
              ?.map((e) => OrderStatusHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customer,
      'items': items,
      'amount': amount,
      'status': status.displayName,
      'placed_at': placedAt.toUtc().toIso8601String(),
      'status_history': statusHistory.map((h) => h.toJson()).toList(),
    };
  }
}

OrderStatus _parseStatus(String statusStr) {
  switch (statusStr.toLowerCase()) {
    case 'placed':
      return OrderStatus.placed;
    case 'packed':
      return OrderStatus.packed;
    case 'shipped':
      return OrderStatus.shipped;
    case 'out for delivery':
      return OrderStatus.outForDelivery;
    case 'delivered':
      return OrderStatus.delivered;
    case 'cancelled':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.placed; // Fallback
  }
}
