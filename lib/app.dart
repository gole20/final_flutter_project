import 'package:flutter/material.dart';

import 'view/onboarding_page_view.dart';

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
        primarySwatch: Colors.grey,
        fontFamily: 'Montserrat-Bold',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Montserrat-Bold', fontSize: 18),
          bodyMedium: TextStyle(fontFamily: 'Montserrat-Bold', fontSize: 16),
          bodySmall: TextStyle(fontFamily: 'Montserrat-Bold', fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(fontFamily: 'Montserrat-Bold'),
          ),
        ),
      ),
      home: const OnboardingPageView(),
    );
  }
}
