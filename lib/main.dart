import 'package:final_flutter_project/app/app.dart';
import 'package:final_flutter_project/features/auth/data/model/shoe_hive_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// final
// const

// HOT RELOAD
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the adapter
  Hive.registerAdapter(ShoeHiveModelAdapter());

  runApp(MyApp());
}
