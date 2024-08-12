import 'package:seek_commerce/models/reviews.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String description;
  final double? averageRating;
  final List<String> imagePaths;
  final List<Review>? reviews;

  Product({required this.id, required this.name, required this.price,required this.stock, required this.description, this.averageRating, required this.imagePaths, this.reviews});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      stock: json['stock'].toInt(),
      description: json['description'],
      averageRating: json['average_rating'].toDouble(),
      imagePaths: List<String>.from(json['image_paths']),
      reviews: (json['reviews'] as List).map((data) => Review.fromJson(data)).toList(),
    );
  }
}