import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seek_commerce/theme/app_theme.dart';

import '../api_config.dart';
import '../models/products.dart';
import '../screens/product_detail_screen.dart';
import '../services/category_service.dart';
import '../services/product_service.dart';
import 'cart_screen.dart';
import 'notifications_screen.dart';

class ExploreScreen extends StatefulWidget {
  final String? query;
  final String? category;
  const ExploreScreen({super.key, this.query, this.category});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;
  List<Product> products = [];
  List<String> categories = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  double? _selectedMinPrice;
  double? _selectedMaxPrice;
  double? _selectedRating;

  final List<String> priceRanges = [
    '0-50',
    '50-100',
    '100-200',
    '200-500',
    '500+'
  ];
  final List<String> ratings = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    super.initState();
    if (widget.query != null) {
      _searchController.text = widget.query!;
    }
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      List<String> fetchedCategories =
          await CategoryService().fetchCategoriesName();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  Future<void> fetchProducts() async {
    if (_selectedCategory != null ||
        _selectedMinPrice != null ||
        _selectedMaxPrice != null ||
        _selectedRating != null) {
      await filterProducts();
    } else if (_searchController.text.isNotEmpty) {
      await searchProducts();
    } else {
      setState(() async {
        products = await ProductService().fetchAllProducts();
      });
    }
  }

  Future<void> searchProducts() async {
    String query = _searchController.text;
    final response = await http.get(
        Uri.parse('$baseUrl/search-product?query=$query'),
        headers: await config.getHeaders());
    if (response.statusCode == 200) {
      setState(() {
        products = (json.decode(response.body) as List)
            .map((data) => Product.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> filterProducts() async {
    final uri = Uri.parse('$baseUrl/filter-product').replace(
      queryParameters: {
        'category': _selectedCategory,
        'price_min': _selectedMinPrice?.toDouble(),
        'price_max': _selectedMaxPrice?.toDouble(),
        'rating': _selectedRating?.toDouble(),
      },
    );
    final response = await http.get(uri, headers: await config.getHeaders());
    if (response.statusCode == 200) {
      setState(() {
        products = (json.decode(response.body) as List)
            .map((data) => Product.fromJson(data))
            .toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _applyFilters() {
    fetchProducts();
  }

  void clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedMinPrice = null;
      _selectedMaxPrice = null;
      _selectedRating = null;
    });
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore', style: headerText24()),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              fetchProducts();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    fetchProducts();
                  },
                ),
              ),
            ),

            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category, style: bodyText10()),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: bodyText12(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMinPrice != null
                          ? _selectedMinPrice.toString()
                          : null,
                      items: priceRanges.map((String price) {
                        return DropdownMenuItem<String>(
                          value: price.split('-').first,
                          child: Text(
                            'Min $price',
                            style: bodyText10(),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Min Price',
                        labelStyle: bodyText12(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMinPrice = newValue != null
                              ? double.tryParse(newValue)
                              : null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMaxPrice != null
                          ? _selectedMaxPrice.toString()
                          : null,
                      items: priceRanges.map((String price) {
                        return DropdownMenuItem<String>(
                          value: price.split('-').last,
                          child: Text(
                            'Max $price',
                            style: bodyText10(),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Max Price',
                        labelStyle: bodyText12(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMaxPrice = newValue != null
                              ? double.tryParse(newValue)
                              : null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedRating != null
                          ? _selectedRating.toString()
                          : null,
                      items: ratings.map((String rating) {
                        return DropdownMenuItem<String>(
                          value: rating,
                          child: Text(
                            '$rating stars',
                            style: bodyText10(),
                          ),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Rating',
                        labelStyle: bodyText12(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRating = newValue != null
                              ? double.tryParse(newValue)
                              : null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: clearFilters,
                    child: const Icon(Icons.clear),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Products List
            Expanded(
              child: products.isEmpty
                  ? const Center(child: Text('No products found'))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                        product: product)));
                          },
                          child: Card(
                            margin: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Carousel Slider for product images
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 200,
                                    autoPlay: true,
                                    viewportFraction: 1.0,
                                    enlargeCenterPage: false,
                                  ),
                                  items: product.imagePaths.map((imagePath) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Image.network(
                                            '$baseUrl/$imagePath',
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(product.name,
                                      style: headerText14(),
                                ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('\$ ${product.price.toString()}',
                                      style: bodyText12().copyWith(color: primaryColor)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
