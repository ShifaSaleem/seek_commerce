import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categories.dart';
import '../api_config.dart';

class CategoryService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
        Uri.parse('$baseUrl/get-categories'), headers: await config.getHeaders());
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load category.');
    }
  }

  Future<List<String>> fetchCategoriesName() async {
    final response = await http.get(Uri.parse('$baseUrl/get-categories'));
    if (response.statusCode == 200) {
      List<dynamic> categoriesJson = json.decode(response.body);
      List<String> categories = categoriesJson.map((category) => category['category_name'].toString()).toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}