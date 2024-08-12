import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seek_commerce/theme/app_theme.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:seek_commerce/components/button.dart';
import '../api_config.dart';
import '../models/orders.dart';
import '../services/order_service.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String shippingAddress;
  final String billingAddress;
  final String contact;
  const PaymentScreen(
      {super.key,
      required this.amount,
      required this.shippingAddress,
      required this.billingAddress,
      required this.contact});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntentData;
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;
  int isSelected = 0;
  String selectedPaymentMethod = 'stripe';
  OrderService _orderService = OrderService();
  String? paymentMethodId;
  String? paymentIntentId;

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = config.stripePubKey;
  }

  Future<void> createPaymentIntent(double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-payment-intent'),
        headers: await config.getHeaders(),
        body: json.encode({'amount': amount}),
      );

      paymentIntentData = json.decode(response.body);
    } catch (err) {
      print('Error creating payment intent: $err');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Test',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // On success, pass the payment method ID and payment intent ID to your backend
      paymentMethodId = paymentIntentData!['payment_method_id'];
      paymentIntentId = paymentIntentData!['id'];

      await _submitOrder();
    } on StripeException catch (e) {
      print('Error displaying payment sheet: $e');
    }
  }

  Future<void> _submitOrder() async {
    try {
      Map<String, dynamic> paymentDetails = {
        if (selectedPaymentMethod == 'stripe')
          'payment_method_id': paymentMethodId,
        'payment_intent_id': paymentIntentId,
        // Add other payment details if necessary
      };

      await _orderService.createOrder(
          paymentMethodName: selectedPaymentMethod,
          billingAddress: widget.billingAddress,
          shippingAddress: widget.shippingAddress,
          contactNumber: widget.contact,
          paymentDetails: paymentDetails);
    } catch (e) {
      print('Failed to create order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Confirm Payment',
          style: headerText24(),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Row(
            children: [
              _paymentMethods(index: 0, name: 'Stripe'),
              _paymentMethods(index: 1, name: 'Bank'),
              _paymentMethods(index: 2, name: 'Card'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
              child: isSelected == 0
                  ? _stripePayment()
                  : isSelected == 1
                      ? Center(
                          child: Text(
                              'Bank Payment not supported at this moment.',
                              style: bodyText16()),
                        )
                      : Center(
                          child: Text(
                              'Card Payment not supported at this moment.',
                              style: bodyText16()),
                        )),
        ]),
      ),
    );
  }

  _paymentMethods({required int index, required String name}) {
    GestureDetector(
      onTap: () => setState(() {
        isSelected = index;
        selectedPaymentMethod = name.toLowerCase();
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

  _stripePayment() {
    Center(
        child: OutlineButton(
      labelText: 'Pay with Stripe',
      textStyle: headerText16().copyWith(color: primaryColor),
      borderColor: primaryColor,
      onPressed: () async {
        await createPaymentIntent(widget.amount);
        await displayPaymentSheet();
      },
    ));
  }
}
