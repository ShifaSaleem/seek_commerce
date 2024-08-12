import 'package:flutter/material.dart';

import '../models/order_products.dart';
import '../models/orders.dart';
import '../models/products.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  ProductService _productService = ProductService();
  @override
  Widget build(BuildContext context) {
    String id = widget.order.id.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: headerText24(),),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed : (){
              Navigator.pop(context);
            }
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('#$id', style: headerText20()),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping Address',
                    style: bodyText14()),
                Text(
                    widget.order.shippingAddress,
                    style: headerText14()),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text('Billing Address',
                    style: bodyText14()),
                Text(
                    widget.order.billingAddress,
                    style: headerText14()),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text('Contact',
                    style: bodyText14()),
                Text(
                    widget.order.contactNumber,
                    style: headerText14()),
              ],
            ),
            SizedBox(height: 16),
            Text('Ordered Products', style: headerText18()),
            SizedBox(height: 10),
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.order.orderProducts.length,
            itemBuilder: (context, index) {
              OrderProduct orderProduct = widget.order.orderProducts[index];
              int p_id = orderProduct.productId;
              Product product = _productService.fetchProduct(p_id) as Product;
                return ListTile(
                  leading: Image.network(product.imagePaths[0], width: 54, height: 50,),
                  title: Text(product.name, style: headerText16(),),
                  subtitle: Text('Quantity: ${orderProduct.quantity}', style: bodyText14()),
                  trailing: Text(orderProduct.price as String, style: headerText14().copyWith(color: primaryColor),),
                );

            },
          )
          ]
        ),
      ),
    );
  }
}
