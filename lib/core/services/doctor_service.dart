// lib/core/services/doctor_service.dart

class DoctorService {
  final List<Map<String, dynamic>> _doctors = [
    // Cardiology
    {"name": "Dr. Ahmad Hassan", "speciality": "Cardiology", "image": "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d", "rating": 4.8},
    {"name": "Dr. Youssef Nabil", "speciality": "Cardiology", "image": "https://images.unsplash.com/photo-1622253692010-333f2da6031d", "rating": 4.9},

    // Dermatology
    {"name": "Dr. Sara Ali", "speciality": "Dermatology", "image": "https://images.unsplash.com/photo-1594824476967-48c8b964273f", "rating": 4.6},
    {"name": "Dr. Layla Zaki", "speciality": "Dermatology", "image": "https://images.unsplash.com/photo-1559839734-2b71ea197ec2", "rating": 4.5},

    // Optometry (Optometry / Ophthalmology)
    {"name": "Dr. Omar Khaled", "speciality": "Optometry", "image": "https://images.unsplash.com/photo-1576765607924-3f7b8410a787", "rating": 4.7},
    {"name": "Dr. Huda Samir", "speciality": "Optometry", "image": "https://images.unsplash.com/photo-1537368910025-700350fe46c7", "rating": 4.4},

    // Dentistry
    {"name": "Dr. Lina Mustafa", "speciality": "Dentistry", "image": "https://images.unsplash.com/photo-1582750433449-648ed127bb54", "rating": 4.5},
    {"name": "Dr. Kareem Farid", "speciality": "Dentistry", "image": "https://images.unsplash.com/photo-1606811841689-23dfddce3e95", "rating": 4.7},

    // Brain & Nerves (Neurology)
    {"name": "Dr. Nader Kamel", "speciality": "Brain & Nerves", "image": "https://images.unsplash.com/photo-1614608682650-e04f05256e29", "rating": 4.8},
    {"name": "Dr. Mona Salah", "speciality": "Brain & Nerves", "image": "https://images.unsplash.com/photo-1618498082410-b4aa22193b38", "rating": 4.6},

    // Orthopedics
    {"name": "Dr. Ali Mahmoud", "speciality": "Orthopedics", "image": "https://images.unsplash.com/photo-1580281657527-47f249e8f15d", "rating": 4.4},
    {"name": "Dr. Samir Fathy", "speciality": "Orthopedics", "image": "https://images.unsplash.com/photo-1622902046581-3a8a1b0b6b6d", "rating": 4.5},

    // Pediatrics
    {"name": "Dr. Rania Fawzy", "speciality": "Pediatrics", "image": "https://images.unsplash.com/photo-1594824476950-1b6c9f0f8a9d", "rating": 4.8},
    {"name": "Dr. Nour Ahmed", "speciality": "Pediatrics", "image": "https://images.unsplash.com/photo-1551601651-2a8555f1a1d3", "rating": 4.7},

    // ENT
    {"name": "Dr. Tamer Fathy", "speciality": "ENT", "image": "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8", "rating": 4.5},
    {"name": "Dr. Dina Wagdy", "speciality": "ENT", "image": "https://images.unsplash.com/photo-1584824486509-112e018196b6", "rating": 4.6},

    // Gynecology
    {"name": "Dr. Amira Adel", "speciality": "Gynecology", "image": "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2", "rating": 4.9},
    {"name": "Dr. Salma Ezz", "speciality": "Gynecology", "image": "https://images.unsplash.com/photo-1567532939604-b6b5b0db2604", "rating": 4.7},
  ];

  // 2. دالة لجلب كل الأطباء
  List<Map<String, dynamic>> getAll() {
    return _doctors;
  }

  // 3. دالة لجلب أطباء اختصاص معين (مفيدة جداً لصفحة الاختصاصات)
  List<Map<String, dynamic>> getBySpeciality(String speciality) {
    return _doctors.where((doc) => doc['speciality'] == speciality).toList();
  }

  // 4. دالة بحث ذكية (للبحث العام)
  List<Map<String, dynamic>> search(String query) {
    return _doctors.where((doc) {
      final name = doc['name'].toString().toLowerCase();
      final spec = doc['speciality'].toString().toLowerCase();
      final q = query.toLowerCase();
      return name.contains(q) || spec.contains(q);
    }).toList();
  }
}