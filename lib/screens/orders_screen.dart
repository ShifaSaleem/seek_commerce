import 'package:flutter/material.dart';

import '../models/orders.dart';
import '../models/products.dart';
import '../services/order_service.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';
import 'order_detail_screen.dart';
import 'notifications_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int isSelected = 0;
  String selectedCategory = 'pending';
  OrderService _orderService = OrderService();
  ProductService _productService = ProductService();
  late Future<List<Order>> pendingOrders;
  late Future<List<Order>> activeOrders;
  late Future<List<Order>> completeOrders;

  @override
  void initState() {
    super.initState();
    pendingOrders = _orderService.fetchSpecifiedOrders('pending');
    activeOrders = _orderService.fetchSpecifiedOrders('active');
    completeOrders = _orderService.fetchSpecifiedOrders('complete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Orders',
            style: headerText24().copyWith(color: textLightColor)),
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
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(children: [
          Row(
            children: [
              _orderCategories(index: 0, name: 'Pending'),
              _orderCategories(index: 1, name: 'Active'),
              _orderCategories(index: 2, name: 'Complete'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isSelected == 0
                ? _ordersListing(
                    orders: pendingOrders, statusColor: Colors.amber)
                : isSelected == 1
                    ? _ordersListing(
                        orders: activeOrders, statusColor: Colors.green)
                    : _ordersListing(
                        orders: completeOrders, statusColor: Colors.indigo),
          ),
        ]),
      ),
    );
  }

  _orderCategories({required int index, required String name}) {
    GestureDetector(
      onTap: () => setState(() {
        isSelected = index;
        selectedCategory = name.toLowerCase();
      }),
      child: Container(
        width: 100,
        height: 40,
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: isSelected == index ? primaryColor : iconColor,
            borderRadius: BorderRadius.circular(30)),
        child: Text(
          name,
          style: isSelected == index
              ? headerText14().copyWith(color: textLightColor)
              : bodyText14().copyWith(color: bodyTextColor),
        ),
      ),
    );
  }

  _ordersListing(
      {required Future<List<Order>> orders, required Color statusColor}) {
    FutureBuilder<List<Order>>(
      future: orders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No orders found'));
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Order order = snapshot.data![index];
              int p_id = order.orderProducts[0].productId;
              Product product = _productService.fetchProduct(p_id) as Product;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailScreen(order: order)));
                },
                child: ListTile(
                  leading: Image.network(product.imagePaths[0],
                      width: 50, height: 54),
                  title: Text(
                    order.id as String,
                    style: headerText16(),
                  ),
                  subtitle: Text(
                    order.status,
                    style: bodyText14().copyWith(color: statusColor),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
