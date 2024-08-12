import 'cart_items.dart';

class Cart {
  final int id;
  final String status;
  final List<CartItem> items;

  Cart({required this.id, required this.status, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<CartItem> itemsList = itemsJson.map((item) => CartItem.fromJson(item)).toList();

    return Cart(
      id: json['id'],
      status: json['status'],
      items: itemsList,
    );
  }
}