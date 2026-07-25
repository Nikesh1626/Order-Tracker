import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/order.dart';

const String kApiUrl = 'https://raw.githubusercontent.com/Nikesh1626/Order-Tracker/main/mock_api.json';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Order>> fetchOrders() async {
    try {
      // Simulate slight network latency to show loading state even though github is fast
      await Future.delayed(const Duration(milliseconds: 800)); 

      // Append a timestamp to the URL to bypass aggressive caching from GitHub raw content
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final response = await _dio.get('$kApiUrl?t=$timestamp');
      
      if (response.statusCode == 200) {
        dynamic decodedData = response.data;
        if (decodedData is String) {
          decodedData = jsonDecode(decodedData);
        }
        final List<dynamic> data = decodedData;
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      // For demo purposes, if the API call fails, we might just throw or fallback to mock data.
      // The prompt asks to handle error state if fetch fails.
      throw Exception('Network error or invalid data: $e');
    }
  }

  List<Order> _getMockOrders() {
    return [
      Order(
        id: 'ORD-1001',
        customer: 'Aditi Rao',
        items: ['Wireless Mouse', 'USB-C Cable'],
        amount: 1299.00,
        status: OrderStatus.delivered,
        placedAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
        statusHistory: [
          OrderStatusHistory(status: OrderStatus.placed, timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 5))),
          OrderStatusHistory(status: OrderStatus.packed, timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 1))),
          OrderStatusHistory(status: OrderStatus.shipped, timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8))),
          OrderStatusHistory(status: OrderStatus.delivered, timestamp: DateTime.now().subtract(const Duration(hours: 4))),
        ],
      ),
      Order(
        id: 'ORD-1002',
        customer: 'John Doe',
        items: ['Mechanical Keyboard'],
        amount: 5499.00,
        status: OrderStatus.outForDelivery,
        placedAt: DateTime.now().subtract(const Duration(days: 1)),
        statusHistory: [
          OrderStatusHistory(status: OrderStatus.placed, timestamp: DateTime.now().subtract(const Duration(days: 1))),
          OrderStatusHistory(status: OrderStatus.packed, timestamp: DateTime.now().subtract(const Duration(hours: 20))),
          OrderStatusHistory(status: OrderStatus.shipped, timestamp: DateTime.now().subtract(const Duration(hours: 10))),
          OrderStatusHistory(status: OrderStatus.outForDelivery, timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
        ],
      ),
      Order(
        id: 'ORD-1003',
        customer: 'Jane Smith',
        items: ['Gaming Monitor', 'HDMI Cable'],
        amount: 18999.00,
        status: OrderStatus.shipped,
        placedAt: DateTime.now().subtract(const Duration(days: 3)),
        statusHistory: [
          OrderStatusHistory(status: OrderStatus.placed, timestamp: DateTime.now().subtract(const Duration(days: 3))),
          OrderStatusHistory(status: OrderStatus.packed, timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 10))),
          OrderStatusHistory(status: OrderStatus.shipped, timestamp: DateTime.now().subtract(const Duration(days: 1))),
        ],
      ),
      Order(
        id: 'ORD-1004',
        customer: 'Alice Johnson',
        items: ['Noise Cancelling Headphones'],
        amount: 8999.00,
        status: OrderStatus.packed,
        placedAt: DateTime.now().subtract(const Duration(hours: 12)),
        statusHistory: [
          OrderStatusHistory(status: OrderStatus.placed, timestamp: DateTime.now().subtract(const Duration(hours: 12))),
          OrderStatusHistory(status: OrderStatus.packed, timestamp: DateTime.now().subtract(const Duration(hours: 5))),
        ],
      ),
      Order(
        id: 'ORD-1005',
        customer: 'Bob Brown',
        items: ['Webcam 1080p'],
        amount: 2499.00,
        status: OrderStatus.placed,
        placedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        statusHistory: [
          OrderStatusHistory(status: OrderStatus.placed, timestamp: DateTime.now().subtract(const Duration(minutes: 45))),
        ],
      ),
      Order(
        id: 'ORD-1006',
        customer: 'Charlie Davis',
        items: ['USB Hub 7-Port'],
        amount: 1199.00,
        status: OrderStatus.cancelled,
        placedAt: DateTime.now().subtract(const Duration(days: 5)),
        statusHistory: [
          OrderStatusHistory(status: OrderStatus.placed, timestamp: DateTime.now().subtract(const Duration(days: 5))),
          OrderStatusHistory(status: OrderStatus.cancelled, timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 2))),
        ],
      ),
      Order(
        id: 'ORD-1007',
        customer: 'Diana Prince',
        items: ['Laptop Stand', 'Ergonomic Mouse'],
        amount: 4599.00,
        status: OrderStatus.shipped,
        placedAt: DateTime.now().subtract(const Duration(days: 2)),
        statusHistory: [
          OrderStatusHistory(status: OrderStatus.placed, timestamp: DateTime.now().subtract(const Duration(days: 2))),
          OrderStatusHistory(status: OrderStatus.packed, timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 22))),
          OrderStatusHistory(status: OrderStatus.shipped, timestamp: DateTime.now().subtract(const Duration(hours: 14))),
        ],
      ),
      Order(
        id: 'ORD-1008',
        customer: 'Evan Wright',
        items: ['External SSD 1TB'],
        amount: 9999.00,
        status: OrderStatus.delivered,
        placedAt: DateTime.now().subtract(const Duration(days: 10)),
        statusHistory: [
          OrderStatusHistory(status: OrderStatus.placed, timestamp: DateTime.now().subtract(const Duration(days: 10))),
          OrderStatusHistory(status: OrderStatus.packed, timestamp: DateTime.now().subtract(const Duration(days: 9))),
          OrderStatusHistory(status: OrderStatus.shipped, timestamp: DateTime.now().subtract(const Duration(days: 8))),
          OrderStatusHistory(status: OrderStatus.outForDelivery, timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 10))),
          OrderStatusHistory(status: OrderStatus.delivered, timestamp: DateTime.now().subtract(const Duration(days: 5, hours: 1))),
        ],
      ),
    ];
  }
}
