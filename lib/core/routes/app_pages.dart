import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:tabibi/core/routes/app_routes.dart';
import 'package:tabibi/features/Help%20&%20Support/binding/help_support_binding.dart';
import 'package:tabibi/features/Help%20&%20Support/view/help_support_view.dart';
import 'package:tabibi/features/appointments/binding/appointments_binding.dart';
import 'package:tabibi/features/appointments/view/appointments_view.dart';
import 'package:tabibi/features/favorites/binding/favorites_doctors_binding.dart';
import 'package:tabibi/features/favorites/view/favorites_doctors_view.dart';
import 'package:tabibi/features/medical_records/binding/medical_records_binding.dart';
import 'package:tabibi/features/medical_records/view/medical_records_view.dart';
import 'package:tabibi/features/profile/binding/profile_binding.dart';
import 'package:tabibi/features/profile/view/profile_view.dart';
import 'package:tabibi/features/settings/binding/binding_settings.dart';
import 'package:tabibi/features/settings/view/view_settings.dart';

class AppPages {
  static final pages = [
   GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    /*GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),*/
    GetPage(
  name: AppRoutes.settings,
  page: () => SettingsView(),
  binding: SettingsBinding(),
),GetPage(
  name: AppRoutes.appointments,

  page: () => const AppointmentsView(),

  binding: AppointmentsBinding(),
),
GetPage(
  name: AppRoutes.medicalRecords,
  page: () => const MedicalRecordsView(),
  binding: MedicalRecordsBinding(),
),
GetPage(
  name: '/favorites',
  page: () => const FavoritesDoctorsView(),
  binding: FavoritesDoctorsBinding(),
),

    GetPage(
      name: AppRoutes.helpSupport,
      page: () => const HelpSupportView(),
      binding: HelpSupportBinding(),
    ),


  ];
}