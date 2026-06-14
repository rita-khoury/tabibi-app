import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabibi/core/routes/app_routes.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboarding_seen', true);

    Get.offAllNamed(AppRoutes.home);
  }

  Widget buildPage({
    required String imagePath,
    required String title,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.6),
                Colors.black.withValues(alpha: 0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 24,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black54,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: Color(0xff1E88E5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          titleWidget: const SizedBox(),
          bodyWidget: const SizedBox(),
          image: buildPage(
            imagePath: 'assets/images/photo1.png',
            title: "Book your appointment easily",
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 1,
          ),
        ),
        PageViewModel(
          titleWidget: const SizedBox(),
          bodyWidget: const SizedBox(),
          image: buildPage(
            imagePath: 'assets/images/photo2.png',
            title: "Your information is safe and secure",
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 1,
          ),
        ),
        PageViewModel(
          titleWidget: const SizedBox(),
          bodyWidget: const SizedBox(),
          image: buildPage(
            imagePath: 'assets/images/photo3.png',
            title: "Track your health status",
          ),
          decoration: const PageDecoration(
            fullScreen: true,
            bodyFlex: 0,
            imageFlex: 1,
          ),
        ),
      ],
      showSkipButton: true,
      skip: const Text(
        "Skip",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Color(0xff1E88E5),
      ),
      done: const Text(
        "Get Started",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xff1E88E5),
        ),
      ),
      onDone: () async {
        await completeOnboarding();
      },
      onSkip: () async {
        await completeOnboarding();
      },
      dotsDecorator: const DotsDecorator(
        activeColor: Color(0xff1E88E5),
        size: Size(8, 8),
        activeSize: Size(18, 8),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}