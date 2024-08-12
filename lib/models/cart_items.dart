import 'package:seek_commerce/models/products.dart';

class CartItem {
  final int id;
  final int quantity;
  final double price;
  final Product product;

  CartItem({required this.id, required this.quantity, required this.price, required this.product});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      product: Product.fromJson(json['product']),
    );
  }
}