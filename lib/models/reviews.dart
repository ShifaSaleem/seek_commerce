class Review {
  final int productId;
  final int userId;
  final String review;
  final double rating;

  Review({
    required this.productId,
    required this.userId,
    required this.review,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      productId: json['product_id'],
      userId: json['user_id'],
      review: json['review'],
      rating: json['rating'].toDouble(),
    );
  }
}