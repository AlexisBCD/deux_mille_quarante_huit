import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Forcer l'orientation portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Nature',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: kIsWeb ? const WebWrapper() : const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebWrapper extends StatelessWidget {
  const WebWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Taille iPhone 16 : 393 x 852
    const double iPhoneWidth = 393.0;
    const double iPhoneHeight = 852.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: iPhoneWidth,
          height: iPhoneHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: const HomePage(),
        ),
      ),
    );
  }
}