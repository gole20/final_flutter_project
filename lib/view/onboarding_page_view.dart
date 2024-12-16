import 'package:final_flutter_project/view/shoe_splash_view.dart';
import 'package:flutter/material.dart';


class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the image
          Center(
            child: Image.asset(
              'assets/hello.png', 
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 30),
          // "Get Started" Button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoeSplashView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text(
          'Welcome to KickBack Shoes!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
