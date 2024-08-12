import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:seek_commerce/components/button.dart';
import 'package:seek_commerce/models/products.dart';
import 'package:seek_commerce/theme/app_theme.dart';
import '../api_config.dart';
import '../models/users.dart';
import '../services/cart_service.dart';
import '../services/user_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final UserService _userService = UserService();
  final CartService _cartService = CartService();
  int _quantity = 1;
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  void _addToCart() async {
    try {
      await _cartService.addItem(widget.product.id, _quantity);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Added to cart')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add to cart')));
    }
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name, style: headerText24()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed : (){
            Navigator.pop(context);
          }
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Slider
          CarouselSlider(
            options: CarouselOptions(
              height: 320, // Adjust height as needed
              autoPlay: true,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 3),
            ),
            items: widget.product.imagePaths.map((imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image.network(
                      '$baseUrl/$imagePath',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Text('Image not available'));
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          // Product Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: headerText20(),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: headerText16().copyWith(color: primaryColor),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      widget.product.description,
                      style: bodyText14(),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
                DefaultButton(
                    labelText: 'Add to Cart',
                    textStyle: headerText16().copyWith(color: textLightColor),
                    onPressed: _addToCart,
                    backgroundColor: primaryColor),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: _decrementQuantity,
                    ),
                    Text('$_quantity', style: headerText14()),
                    IconButton(
                      icon: Icon(Icons.add, color: primaryColor),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Reviews
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Reviews',
                style: headerText18(),
              ),
              SizedBox(height: 8.0),
              // List of reviews
              widget.product.reviews!.isEmpty
                  ? Text('No reviews yet', style: bodyText14())
                  : ListView.builder(
                      itemCount: widget.product.reviews!.length,
                      itemBuilder: (context, index) {
                        final review = widget.product.reviews![index];
                        User user =
                            _userService.getProfile(review.userId) as User;
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(user.profileImage!),
                                radius: 20,
                              ),
                              title: Text(
                                user.name,
                                style: headerText16(),
                              ),
                              subtitle: Column(children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(review.rating.toString())
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  review.review,
                                  style: bodyText14(),
                                ),
                              ]),
                            ));
                      }),
            ]),
          )
        ],
      )),
    );
  }
}
