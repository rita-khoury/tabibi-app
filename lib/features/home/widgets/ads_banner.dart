import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AdsBanner extends StatefulWidget {
  const AdsBanner({super.key});

  @override
  State<AdsBanner> createState() => _AdsBannerState();
}

class _AdsBannerState extends State<AdsBanner> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  Timer? _timer;

  final List<Map<String, dynamic>> adsList = [
    {
      "title": "Medical Checkup",
      "subtitle": "Get 20% off your first visit",
      "image": "assets/images/img4.png",
      "color": const Color(0xff2F80ED),
    },
    {
      "title": "Online Consultation",
      "subtitle": "Talk to top doctors 24/7",
      "image": "assets/images/img_3.png",
      "color": const Color(0xff56CCF2),
    },
    {
      "title": "Pharmacy Delivery",
      "subtitle": "Get your medicines at your door",
      "image": "assets/images/img_2.png",
      "color": const Color(0xff27AE60),
    },
    {
      "title": "Lab Tests",
      "subtitle": "Accurate results in fast time",
      "image": "assets/images/img_1.png",
      "color": const Color(0xffF2994A),
    },
    {
      "title": "Emergency Care",
      "subtitle": "Available 24/7 for safety",
      "image": "assets/images/img.png",
      "color": const Color(0xffE74C3C),
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int next = (_pageController.page?.toInt() ?? 0) + 1;
        if (next >= adsList.length) next = 0;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
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
        SizedBox(
          height: 130,
          child: PageView.builder(
            controller: _pageController,
            itemCount: adsList.length,
            itemBuilder: (context, index) {
              final ad = adsList[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        ad['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[300]),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              ad['color'].withOpacity(0.8),
                              ad['color'].withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ad['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ad['subtitle'],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: adsList.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: Colors.blueAccent,
            dotColor: Colors.black26,
          ),
        ),
      ],
    );
  }
}
