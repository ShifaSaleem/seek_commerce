

import 'order_products.dart';

class Order {
  final int id;
  final int userId;
  final double totalPrice;
  final String status;
  final String billingAddress;
  final String shippingAddress;
  final String contactNumber;
  final List<OrderProduct> orderProducts;

  Order({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.billingAddress,
    required this.shippingAddress,
    required this.contactNumber,
    required this.orderProducts,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      totalPrice: json['total_price'],
      status: json['status'],
      billingAddress: json['billing_address'],
      shippingAddress: json['shipping_address'],
      contactNumber: json['contact'],
      orderProducts: List<OrderProduct>.from(json['order_products']),

    );
  }

}