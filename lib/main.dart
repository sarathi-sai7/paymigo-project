import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/how_it_works_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/demo_screen.dart';
import 'screens/plans_screen.dart';
import 'screens/onboard_screen.dart';
import 'screens/admin_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const PaymigoApp());
}

class PaymigoApp extends StatelessWidget {
  const PaymigoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paymigo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF5500),
        ),
        useMaterial3: true,
      ),

      /// 🔥 START SCREEN
      initialRoute: "/",

      /// 🔗 ROUTES
      routes: {
        "/": (context) => const LandingScreen(),
        "/login": (context) => const LoginScreen(),
        "/dashboard": (context) => const DashboardScreen(),
        "/profile": (context) => const ProfileScreen(),
        "/demo": (context) => const DemoScreen(),
        "/plans": (context) => const PlansScreen(),
        "/onboard": (context) => const OnboardScreen(),
        "/admin": (context) => const AdminScreen(),
        "/how-it-works": (context) => const HowItWorksScreen(),

      },
    );
  }
}