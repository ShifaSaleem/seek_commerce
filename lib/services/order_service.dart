import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_config.dart';
import '../models/orders.dart';


class OrderService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: await config.getHeaders()
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> fetchOrder(int orderId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/order/{$orderId}'),
        headers: await config.getHeaders()
    );

    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load order');
    }
  }

  Future<List<Order>> fetchSpecifiedOrders(String status) async {
    final response = await http.get(
        Uri.parse('$baseUrl/specified-orders?status=$status'),
        headers: await config.getHeaders()
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<Order> createOrder({
    required String paymentMethodName,
    required String billingAddress,
    required String shippingAddress,
    required String contactNumber,
    required Map<String, dynamic> paymentDetails,
  }) async {

    final response = await http.post(
      Uri.parse('$baseUrl/save-order'),
      headers: await config.getHeaders(),
      body: jsonEncode({
        'payment_method_name': paymentMethodName,
        'billing_address': billingAddress,
        'shipping_address': shippingAddress,
        'contact_number': contactNumber,
        'payment_details': paymentDetails,
      }),
    );

    if (response.statusCode == 201) {
      return Order.fromJson(jsonDecode(response.body)['order']);
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update-order-status/$orderId/status'),
      headers: await config.getHeaders(),
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update order status');
    }
  }
}