import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Stripppe extends StatefulWidget {
  const Stripppe({super.key});

  @override
  State<Stripppe> createState() => _StripppeState();
}

class _StripppeState extends State<Stripppe> {
  dynamic paymentIntent;
// Make Payment
  Future<void> makePayment() async {
    try {
      // STEP 1: Creat Payment Intent
      paymentIntent = await createPaymentIntent('100', 'USD');

      // STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent['client_secret']
                  // Gotten from payment intent
                  ,
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ikey'))
          .then((value) {});
      //STEP 3: Display Payment sheet
      didChangeDependencies();
    } catch (e) {
      print(e);
    }
  }

// Creat Payment Intent
  createPaymentIntent(String currency, String amount) async {
    try {
      // Request body
      Map<String, dynamic> body = {'amount': amount, 'currency': currency};

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization':
                'Bearer sk_test_51NSHG5BEWhyNTRjQ28leyBIiF48gtmfOgvfRplEe5NuorKWedyrSm4Se6VtGmr1Twk681vhU1Vyf5cINUMiD49QP00ZC59qqaA',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body);
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }

// Display Sheet
  displayPamentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  Text('Payment Successfully')
                ]),
          ),
        );
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print(e);
      const AlertDialog(
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            children: [
              Icon(
                Icons.cancel,
                color: Colors.redAccent,
              ),
              Text('Payment Failed')
            ],
          )
        ]),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 140, 255),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
            style: TextStyle(color: Colors.white),'Stripe Payment Gateway'),
      ),
      body: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 94, 255),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              makePayment();
            },
            child: const Text(style: TextStyle(color: Colors.white),'Start')),
      ),
    );
  }
}
