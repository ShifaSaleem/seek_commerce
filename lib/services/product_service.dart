import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/products.dart';
import '../api_config.dart';


class ProductService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'), headers: await config.getHeaders());

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product?> fetchProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/product/{$id}'), headers: await config.getHeaders());

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Product.fromJson(responseData);
    } else {

      return null;
    }
  }

  Future<List<Product>> fetchTopProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/top-products'), headers: await config.getHeaders());

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Product>> fetchSuggestedProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/suggested-products'), headers: await config.getHeaders());

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

}


