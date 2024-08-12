import 'package:flutter/material.dart';

import '../models/products.dart';
import '../theme/app_theme.dart';

class TopProducts extends StatelessWidget {
  final Product product;

  TopProducts({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.0, // Adjust width as needed
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Image.network(product.imagePaths[0], height: 120.0, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30.0)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(product.averageRating as String, style: bodyText8().copyWith(color: textLightColor),),
              ),
            )
          ]),
          const SizedBox(height: 8.0),
          Text(product.name, style: headerText14()),
          const SizedBox(height: 4.0),
          Text('\$${product.price}', style: bodyText12()),
        ],
      ),
    );
  }
}
