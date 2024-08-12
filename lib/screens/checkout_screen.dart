import 'package:flutter/material.dart';
import 'package:seek_commerce/components/button.dart';
import 'package:seek_commerce/input_validators/input_validators.dart';
import 'package:seek_commerce/provider/auth_provider.dart';
import 'package:seek_commerce/screens/payment_screen.dart';
import 'package:seek_commerce/screens/signup_screen.dart';
import 'package:seek_commerce/screens/home_screen.dart';
import 'package:seek_commerce/theme/app_theme.dart';
import '../components/input_fields.dart';

class CheckoutScreen extends StatefulWidget {
  final double amount;
  const CheckoutScreen({super.key, required this.amount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _shippingController = TextEditingController();
  final _billingController = TextEditingController();
  final _contactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Checkout', style: headerText24(),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DefaultTextField(
              prefixIcon: Icon(Icons.location_city),
              labelText: 'Shipping Address',
              hintText: 'Enter Shipping Address',
              textInputType: TextInputType.streetAddress,
              controller: _shippingController,
              validator: validateEmail,
            ),
            SizedBox(height: 16),
            DefaultTextField(
              prefixIcon: Icon(Icons.location_city),
              labelText: 'Billing Address',
              hintText: 'Enter Billing Address',
              textInputType: TextInputType.streetAddress,
              controller: _billingController,
              validator: validateEmail,
            ),
            SizedBox(height: 16),
            DefaultTextField(
              prefixIcon: Icon(Icons.phone),
              labelText: 'Contact No.',
              hintText: 'Enter Contact No',
              textInputType: TextInputType.phone,
              controller: _contactController,
              validator: validateEmail,
            ),
            SizedBox(height: 16),
            DefaultButton(
              labelText: 'Checkout',
              textStyle: headerText16()
                  .copyWith(color: textLightColor),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    PaymentScreen(
                      amount: widget.amount,
                      shippingAddress: _shippingController.text,
                      billingAddress: _billingController.text,
                      contact: _contactController.text,
                    )));
              },
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
