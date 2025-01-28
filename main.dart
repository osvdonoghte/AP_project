import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'user_profile_page.dart';
import 'auth_screen.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'category_product_screen.dart';
import 'payment_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nike E-commerce',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: Colors.teal,
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleMedium: TextStyle(color: Colors.white70),
          labelLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
      ),
      initialRoute: '/login', // Ensures login is the starting point
      routes: {
        '/login': (context) => const AuthScreen(), // Authentication screen
        '/home': (context) => const HomeScreen(), // Home screen after login
        '/categories': (context) => const CategoryScreen(), // Categories screen
        '/profile': (context) => UserProfilePage(
          userDetails: ModalRoute.of(context)?.settings.arguments as UserDetails,
        ),
        '/cart': (context) => CartScreen(
          cartItems: ModalRoute.of(context)?.settings.arguments as List<dynamic> ?? [],
        ),
        '/payment': (context) => PaymentPage(
          paymentAmount: ModalRoute.of(context)?.settings.arguments as double? ?? 0.0,
        ),
      },
    );
  }
}
