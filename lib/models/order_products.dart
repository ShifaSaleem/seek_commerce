
class OrderProduct {
  final int productId;
  final int quantity;
  final double price;

  OrderProduct({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct (
      productId : json['product_id'],
      quantity : json['quantity'],
      price : json['price'],

  );

  }
}