import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/specialities_section.dart';

class AllSpecialitiesPage extends StatelessWidget {
  const AllSpecialitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded,
              size: 35, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("All Specialities"),
        backgroundColor: const Color(0xffF5F7FB),
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: const Padding(
        padding: EdgeInsets.all(15),
        child: SpecialitiesSection(isGrid: true),
      ),
    );
  }
}