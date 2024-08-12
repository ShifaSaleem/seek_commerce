class Category {
  final int id;
  final String categoryName;
  final String categoryImage;


  Category({
    required this.id,
    required this.categoryName,
    required this.categoryImage
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
    );
  }
}