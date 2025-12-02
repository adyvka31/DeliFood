import 'package:ecommerce_mobile/features/onboarding/onboarding.dart';
import 'package:ecommerce_mobile/prefrences/color.dart';
import 'package:ecommerce_mobile/service/database_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  void _startApp() async {
    // 1. Jalankan proses cek & upload data di background
    await DatabaseService().seedDatabase();

    // 2. Beri jeda sedikit (opsional, untuk estetika splash screen)
    await Future.delayed(const Duration(seconds: 2));

    // 3. Pindah ke halaman berikutnya
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColors.secondaryColor,
      body: Center(child: Image.asset('assets/images/splash.png', width: 130)),
    );
  }
}
