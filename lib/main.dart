import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_app/Screens/Splash_Screen.dart/Splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Wrap with MaterialApp to provide Directionality
      home: KeyedSubtree(
        key: key,
        child: const SplashScreen(), // Provide your SplashScreen widget here
      ),
    );
  }
}
