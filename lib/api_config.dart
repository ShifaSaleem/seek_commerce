import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConfig {
  final String baseUrl = 'https://localhost:8000/api';
  final String stripePubKey = 'pk_test_51PhD7mKljfYCasI0366IJ1uBj3TDOcJY3KlPHb3m7fi1fFyBNqxJHpG5m0zrOVZnvbuUtx06WChT0iHpFmvPXAdh00tTnHyEWe';
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<Map<String, String>> getHeaders() async {
    String? token = await storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> getHeaders2() async {
    String? token = await storage.read(key: 'token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

}


