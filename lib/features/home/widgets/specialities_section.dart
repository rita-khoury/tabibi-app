import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/DoctorsPage.dart';


final List<Map<String, dynamic>> doctorsList = [
  {"name": "Dr. Ahmad Hassan", "speciality": "Cardiology", "image": "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d", "rating": 4.8},
  {"name": "Dr. Sara Ali", "speciality": "Dermatology", "image": "https://images.unsplash.com/photo-1594824476967-48c8b964273f", "rating": 4.6},
  {"name": "Dr. Omar Khaled", "speciality": "Ophthalmology", "image": "https://images.unsplash.com/photo-1576765607924-3f7b8410a787", "rating": 4.7},
  {"name": "Dr. Lina Mustafa", "speciality": "Dentistry", "image": "https://images.unsplash.com/photo-1582750433449-648ed127bb54", "rating": 4.5},
  {"name": "Dr. Youssef Nabil", "speciality": "Cardiology", "image": "https://images.unsplash.com/photo-1622253692010-333f2da6031d", "rating": 4.9},
  {"name": "Dr. Huda Samir", "speciality": "Neurology", "image": "https://images.unsplash.com/photo-1559839734-2b71ea197ec2", "rating": 4.6},
  {"name": "Dr. Ali Mahmoud", "speciality": "Orthopedics", "image": "https://images.unsplash.com/photo-1580281657527-47f249e8f15d", "rating": 4.4},
  {"name": "Dr. Mona Salah", "speciality": "Pediatrics", "image": "https://images.unsplash.com/photo-1618498082410-b4aa22193b38", "rating": 4.7},
  {"name": "Dr. Tamer Fathy", "speciality": "ENT", "image": "https://images.unsplash.com/photo-1622902046581-3a8a1b0b6b6d", "rating": 4.5},
  {"name": "Dr. Rania Fawzy", "speciality": "Gynecology", "image": "https://images.unsplash.com/photo-1594824476950-1b6c9f0f8a9d", "rating": 4.8},
];

class SpecialitiesSection extends StatelessWidget {
  final bool isGrid;

  const SpecialitiesSection({super.key, this.isGrid = false});

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": Icons.favorite_sharp, "title": "Cardiology"},
      {"icon": Icons.face_sharp, "title": "Dermatology"},
      {"icon": Icons.visibility_sharp, "title": "Optometry"},
      {"icon": Icons.medical_services_sharp, "title": "Dentistry"},
      {"icon": Icons.psychology_sharp, "title": "Brain & Nerves"},
      {"icon": Icons.accessible_sharp, "title": "Orthopedics"},
      {"icon": Icons.child_care_sharp, "title": "Pediatrics"},
      {"icon": Icons.hearing_sharp, "title": "ENT"},
      {"icon": Icons.pregnant_woman_sharp, "title": "Gynecology"},
    ];

    Widget buildItem(int index) {
      return InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Get.to(() => DoctorsPage(
          speciality: items[index]["title"].toString(),
          doctors: doctorsList,
        )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(

                gradient: const LinearGradient(
                  colors: [Color(0xff2F80ED), Color(0xff56CCF2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff2F80ED).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  items[index]["icon"] as IconData,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 80,
              child: Text(
                items[index]["title"].toString(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (isGrid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 18,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) => buildItem(index),
      );
    }

    return SizedBox(
      height: 125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) => Container(
          width: 90,
          margin: const EdgeInsets.only(right: 12),
          child: buildItem(index),
        ),
      ),
    );
  }
}