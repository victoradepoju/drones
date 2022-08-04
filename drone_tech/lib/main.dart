import 'package:drone_tech/src/feature/drone/presentation/drone_page/drone_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    //ProviderScope, the root of our providers (from Riverpod package).
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drone App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const DronePage(),
    );
  }
}
