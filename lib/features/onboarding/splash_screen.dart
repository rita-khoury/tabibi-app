import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double opacity = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        opacity = 1;
      });
    });

    Future.delayed(const Duration(seconds: 4), () {
      Get.offAllNamed(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 219, 238),

      body: SizedBox.expand(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,

          child: Image.asset(
            "assets/images/logo2.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}