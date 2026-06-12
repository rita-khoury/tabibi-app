import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/DoctorsPage.dart';
final List<Map> doctorsList = [
  {
    "name": "Dr. Ahmad Hassan",
    "speciality": "Cardiology",
    "image": "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d",
    "rating": 4.8,
  },
  {
    "name": "Dr. Sara Ali",
    "speciality": "Dermatology",
    "image": "https://images.unsplash.com/photo-1594824476967-48c8b964273f",
    "rating": 4.6,
  },
  {
    "name": "Dr. Omar Khaled",
    "speciality": "Ophthalmology",
    "image": "https://images.unsplash.com/photo-1576765607924-3f7b8410a787",
    "rating": 4.7,
  },
  {
    "name": "Dr. Lina Mustafa",
    "speciality": "Dentistry",
    "image": "https://images.unsplash.com/photo-1582750433449-648ed127bb54",
    "rating": 4.5,
  },
  {
    "name": "Dr. Youssef Nabil",
    "speciality": "Cardiology",
    "image": "https://images.unsplash.com/photo-1622253692010-333f2da6031d",
    "rating": 4.9,
  },
  {
    "name": "Dr. Huda Samir",
    "speciality": "Neurology",
    "image": "https://images.unsplash.com/photo-1559839734-2b71ea197ec2",
    "rating": 4.6,
  },
  {
    "name": "Dr. Ali Mahmoud",
    "speciality": "Orthopedics",
    "image": "https://images.unsplash.com/photo-1580281657527-47f249e8f15d",
    "rating": 4.4,
  },
  {
    "name": "Dr. Mona Salah",
    "speciality": "Pediatrics",
    "image": "https://images.unsplash.com/photo-1618498082410-b4aa22193b38",
    "rating": 4.7,
  },
  {
    "name": "Dr. Tamer Fathy",
    "speciality": "ENT",
    "image": "https://images.unsplash.com/photo-1622902046581-3a8a1b0b6b6d",
    "rating": 4.5,
  },
  {
    "name": "Dr. Rania Fawzy",
    "speciality": "Gynecology",
    "image": "https://images.unsplash.com/photo-1594824476950-1b6c9f0f8a9d",
    "rating": 4.8,
  },
  {
    "name": "Dr. Mostafa Ali",
    "speciality": "Cardiology",
    "image": "https://images.unsplash.com/photo-1612349316213-8b7a9c5f2d2c",
    "rating": 4.6,
  },
  {
    "name": "Dr. Salma Yassin",
    "speciality": "Dermatology",
    "image": "https://images.unsplash.com/photo-1614608682850-e0d6ed316d47",
    "rating": 4.5,
  },
  {
    "name": "Dr. Kareem Adel",
    "speciality": "Ophthalmology",
    "image": "https://images.unsplash.com/photo-1622253692010-333f2da6031d",
    "rating": 4.7,
  },
  {
    "name": "Dr. Nada Hany",
    "speciality": "Dentistry",
    "image": "https://images.unsplash.com/photo-1588776814546-1ffcf47267a5",
    "rating": 4.6,
  },
  {
    "name": "Dr. Mohamed Gamal",
    "speciality": "Orthopedics",
    "image": "https://images.unsplash.com/photo-1580281658621-0e3f6c4c1f1a",
    "rating": 4.4,
  },
  {
    "name": "Dr. Yasmin Adel",
    "speciality": "Neurology",
    "image": "https://images.unsplash.com/photo-1594824476970-3f0b5d5b8a7a",
    "rating": 4.9,
  },
  {
    "name": "Dr. Hossam Farid",
    "speciality": "Cardiology",
    "image": "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d",
    "rating": 4.7,
  },
  {
    "name": "Dr. Reem Tarek",
    "speciality": "Pediatrics",
    "image": "https://images.unsplash.com/photo-1618498082410-b4aa22193b38",
    "rating": 4.6,
  },
  {
    "name": "Dr. Ahmed Nasser",
    "speciality": "ENT",
    "image": "https://images.unsplash.com/photo-1622902046581-3a8a1b0b6b6d",
    "rating": 4.5,
  },
  {
    "name": "Dr. Farah Saad",
    "speciality": "Gynecology",
    "image": "https://images.unsplash.com/photo-1594824476950-1b6c9f0f8a9d",
    "rating": 4.8,
  },
];
class SpecialitiesSection extends StatelessWidget {
  final bool isGrid;

  const SpecialitiesSection({
    super.key,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": Icons.favorite, "title": "Cardiology"},
      {"icon": Icons.spa, "title": "Dermatology"},
      {"icon": Icons.visibility, "title": "Ophthalmology"},
      {"icon": Icons.medical_services, "title": "Dentistry"},
    ];

    Widget buildItem(int index) {
      return InkWell(
        onTap: () {
          Get.to(
                () => DoctorsPage(
              speciality: items[index]["title"].toString(),
              doctors: doctorsList,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(items[index]["icon"] as IconData, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                items[index]["title"].toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) => buildItem(index),
      );
    }


    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: buildItem(index),
          );
        },
      ),
    );
  }
}