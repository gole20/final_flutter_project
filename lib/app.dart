import 'package:final_flutter_project/view/signup_page_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Montserrat-Bold',
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Montserrat-Bold',
          ),
        ),
      ),
      home: const SignUpPageView(),
    );
  }
}
