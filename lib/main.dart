import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_integration/stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      'pk_test_51NSHG5BEWhyNTRjQhoTcoRhEOFLYYbmJsf0CEsybVUv7IOkkyheQmN4cPrjUR5DwpfUgpreR710FKuldt8xsRM4V002D7xyqMJ';

  //Load our .env file that contains our Stripe Secret key
  // await dotenv.load(fileName: 'assets/.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Stripp(),
    );
  }
}
