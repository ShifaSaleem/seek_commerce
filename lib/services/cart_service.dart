import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/cart_items.dart';
import '../models/users.dart';
import '../api_config.dart';
import '../models/cart.dart';

class CartService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<Cart?> getCart() async {
    final response = await http.get(Uri.parse('$baseUrl/cart'), headers: await config.getHeaders());

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body)['cart']);
    } else {
      return null;
    }
  }

  Future<CartItem?> addItem(int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: await config.getHeaders(),
      body: jsonEncode({'product_id': productId, 'quantity': quantity}),
    );

    if (response.statusCode == 201) {
      return CartItem.fromJson(jsonDecode(response.body)['item']);
    } else {
      return null;
    }
  }

  Future<bool> removeItem(int id) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/cart/remove/{$id}'),
        headers: await config.getHeaders());

    return response.statusCode == 200;
  }

  Future<CartItem?> updateItem(int id, int quantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cart/update/{$id}'),
      headers: await config.getHeaders(),
      body: jsonEncode({'quantity': quantity}),
    );

    if (response.statusCode == 200) {
      return CartItem.fromJson(jsonDecode(response.body)['item']);
    } else {
      return null;
    }
  }

  Future<bool> checkout() async {
    final response = await http.post(
        Uri.parse('$baseUrl/checkout'),
        headers: await config.getHeaders());

    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getCharges() async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/get_charges'),
          headers: await config.getHeaders());

      if (response.statusCode == 200) {
        List<dynamic> chargesJson = json.decode(response.body);

        List<Map<String, dynamic>> charges = chargesJson.map((charge) {
          return {
            'charge_name': charge['charge_name'],
            'amount': charge['amount'],
          };
        }).toList();

        return charges;
      } else {
        throw Exception('Failed to load charges');
      }
    } catch (e) {
      print('Error fetching charges: $e');
      return [];
    }
  }
}