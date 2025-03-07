import 'package:final_flutter_project/features/auth/data/model/shoe_hive_model.dart';
import 'package:final_flutter_project/splash/shoe_splash_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(ShoeHiveModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'vvvh',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ShoeSplashView(),
    );
  }
}
