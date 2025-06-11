import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'login_screen.dart';
import 'register_screen.dart';
import 'homepage.dart';
import 'sewa_motor_screen.dart';
import 'charge_screen.dart';
import 'maps_bengkel_screen.dart';
import 'motor_service.dart';
import 'homepage.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Sewa Motor',
      initialRoute: '/login', // <-- Halaman pertama saat app dibuka
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const Homepage(),
        '/sewa': (context) => const SewaMotorScreen(),
        '/charge': (context) => ChargeScreen(),
        '/bengkel': (context) => const MapsBengkelScreen(),
        '/dummy': (context) => const InputDummyMotor(), // untuk testing data dummy
      },
    );
  }
}
