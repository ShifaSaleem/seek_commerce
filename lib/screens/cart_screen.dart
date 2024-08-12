import 'package:flutter/material.dart';

import '../components/button.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';
import '../theme/app_theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  Cart? _cart;
  List<Map<String, dynamic>>? _charges;
  bool _loadingCart = true;
  bool _loadingCharges = true;


  @override
  void initState() {
    super.initState();
    _fetchCart();
    _fetchCharges();
  }

  Future<void> _fetchCart() async {
    setState(() {
      _loadingCart = true;
    });
    _cart = await _cartService.getCart();
    setState(() {
      _loadingCart = false;
    });
  }

  Future<void> _fetchCharges() async {
    setState(() {
      _loadingCharges = true;
    });
    // Assuming the charges API returns a list of maps with 'description' and 'amount'
    _charges = await _cartService.getCharges();
    setState(() {
      _loadingCharges = false;
    });
  }

  double _calculateTotalPrice() {
    if (_cart == null || _charges == null) return 0.0;
    double cartTotal = _cart!.items
        .fold(0.0, (sum, item) => sum + (item.quantity * item.price));
    double chargesTotal =
        _charges!.fold(0.0, (sum, charge) => sum + charge['amount']);
    return cartTotal + chargesTotal;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: headerText24()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 60),
        child: Column(
          children: [
            _loadingCart || _loadingCharges
                ? Center(child: CircularProgressIndicator())
                : _cart == null
                    ? Center(child: Text('Cart not found'))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _cart!.items.length,
                              itemBuilder: (context, index) {
                                final item = _cart!.items[index];
                                return Slidable(
                                  key: ValueKey(item.id),
                                  endActionPane: ActionPane(
                                    motion: BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          final success = await _cartService
                                              .removeItem(item.id);
                                          if (success) {
                                            _fetchCart();
                                          }
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Remove',
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: Image.network(item.product.imagePaths[0], width: 100, height: 100),
                                    title: Text(item.product.name),
                                    subtitle: Text(
                                        'Quantity: ${item.quantity}, Price: \$${item.price}'),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _charges == null
                                    ? SizedBox.shrink()
                                    : Column(
                                        children: _charges!.map((charge) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(charge['charge_name'],
                                                  style: bodyText14()),
                                              Text(
                                                  '\$${charge['amount'].toStringAsFixed(2)}',
                                                  style: headerText14()),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total', style: bodyText16()),
                                    Text(
                                        '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                                        style: headerText16()),
                                  ],
                                ),
                                SizedBox(height: 10),
                                DefaultButton(
                                  labelText: 'Checkout',
                                  textStyle: headerText16()
                                      .copyWith(color: textLightColor),
                                  onPressed: () {
                                    double _totalAmount = _calculateTotalPrice();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(amount: _totalAmount)));
                                  },
                                  backgroundColor: primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
          ],
        ),
      ),
    );
  }
}
