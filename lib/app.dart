
import 'package:final_flutter_project/view/login_page_view.dart';
import 'package:final_flutter_project/view/shoe_splash_view.dart';
import 'package:final_flutter_project/view/signup_page_view.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShoeSplashView(),
    );
  }
}