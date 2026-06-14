import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdsBanner extends StatefulWidget {
  const AdsBanner({super.key});

  @override
  State<AdsBanner> createState() => _AdsBannerState();
}

class _AdsBannerState extends State<AdsBanner> {
  final PageController _pageController = PageController();
  Timer? _timer;

  final List<Map<String, dynamic>> adsList = [
    {"title": "Medical Checkup", "subtitle": "Get 20% off your first visit", "image": "https://img.freepik.com/free-photo/doctor-with-patient-checkup_23-2148827775.jpg", "color": const Color(0xff2F80ED)},
    {"title": "Online Consultation", "subtitle": "Talk to top doctors 24/7", "image": "https://img.freepik.com/free-photo/woman-having-online-consultation_23-2148523363.jpg", "color": const Color(0xff56CCF2)},
    {"title": "Pharmacy Delivery", "subtitle": "Get your medicines at your door", "image": "https://img.freepik.com/free-photo/pharmacist-checking-stock_23-2148827796.jpg", "color": const Color(0xff27AE60)},
    {"title": "Lab Tests", "subtitle": "Accurate results in fast time", "image": "https://img.freepik.com/free-photo/scientist-working-lab_23-2148827771.jpg", "color": const Color(0xffF2994A)},
    {"title": "Emergency Care", "subtitle": "Available 24/7 for safety", "image": "https://img.freepik.com/free-photo/ambulance-car-hospital_23-2148827798.jpg", "color": const Color(0xffE74C3C)},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        int next = (_pageController.page?.toInt() ?? 0) + 1;
        if (next >= adsList.length) next = 0;
        _pageController.animateToPage(next, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2.5,
          child: PageView.builder(
            controller: _pageController,
            itemCount: adsList.length,
            itemBuilder: (context, index) {
              final ad = adsList[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                clipBehavior: Clip.antiAlias, // لقص الصور داخل الحواف الدائرية
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    // الطبقة الأولى: الصورة
                    Positioned.fill(
                      child: Image.network(ad['image'], fit: BoxFit.cover),
                    ),
                    // الطبقة الثانية: لون خفيف (Gradient) لتوضيح النص
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [ad['color'].withOpacity(0.9), ad['color'].withOpacity(0.2)],
                          ),
                        ),
                      ),
                    ),
                    // الطبقة الثالثة: النصوص
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(ad['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 5),
                          Text(ad['subtitle'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: adsList.length,
          effect: const WormEffect(dotHeight: 6, dotWidth: 6, activeDotColor: Colors.blueAccent, dotColor: Colors.black26),
        ),
      ],
    );
  }
}