import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
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
import 'package:tabibi/features/navigation/binding/navigation_binding.dart';
import 'package:tabibi/features/navigation/view/navigation_view.dart';

import 'package:tabibi/features/onboarding/onboarding_screen.dart';
import 'package:tabibi/features/onboarding/splash_screen.dart';
import 'package:tabibi/features/profile/binding/edit_profile_binding.dart';
import 'package:tabibi/features/profile/binding/profile_binding.dart';
import 'package:tabibi/features/profile/view/edit_profile_view.dart';
import 'package:tabibi/features/profile/view/change_password_view.dart';
import 'package:tabibi/features/profile/view/profile_view.dart';
import 'package:tabibi/features/settings/binding/binding_settings.dart';
import 'package:tabibi/features/settings/view/view_settings.dart';

import '../../features/LoginScreen/binding/login_binding.dart';
import '../../features/LoginScreen/view/login_screen.dart';
import '../../features/complete_profile/binding/complete_profile_binding.dart';
import '../../features/complete_profile/middleware/profile_guard.dart';
import '../../features/complete_profile/view/complete_profile_view.dart';
import '../../features/doctor_profile/binding/doctor_profile_binding.dart';
import '../../features/doctor_profile/view/doctor_profile_view.dart';
import '../../features/notifications/controller/notification_controller.dart';
import '../../features/notifications/view/notification_view.dart';
import '../../features/profile/view/violations_view.dart';
import '../../features/wallet/binding/wallet_binding.dart';
import '../../features/wallet/view/wallet_view.dart';

import '../../features/financial_hub/view/financial_hub_view.dart';
import '../../features/financial_hub/controller/transactions_controller.dart';
import '../../features/financial_hub/view/transactions_view.dart';
import '../../features/financial_hub/controller/payments_controller.dart';
import '../../features/financial_hub/view/payments_view.dart';

import 'package:tabibi/features/queue/binding/patient_queue_binding.dart';
import 'package:tabibi/features/queue/view/patient_queue_view.dart';
class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => OnboardingScreen()),
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
    ),
    GetPage(
      name: AppRoutes.appointments,

      page: () => const AppointmentsView(),

      binding: AppointmentsBinding(),
    ),
    GetPage(
      name: AppRoutes.medicalRecords,
      page: () => MedicalRecordView(),
      binding: MedicalRecordBinding(),
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => FavoritesDoctorsView(),
      binding: FavoritesDoctorsBinding(),
    ),
    GetPage(name: AppRoutes.violationsView, page: () => const ViolationsView()),
    GetPage(
      name: AppRoutes.helpSupport,
      page: () => const HelpSupportView(),
      binding: HelpSupportBinding(),
    ),

    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const NavigationView(),
      binding: NavigationBinding(),
    ),

    GetPage(
      name: '/medical-profile',
      page: () => CompleteProfileView(),
      binding: CompleteProfileBinding(),
      middlewares: [ProfileMiddleware()],
    ),
    GetPage(
      name: AppRoutes.wallet,

      page: () => const WalletView(),

      binding: WalletBinding(),
    ),
    GetPage(name: AppRoutes.financialHub, page: () => const FinancialHubView()),
    GetPage(
      name: AppRoutes.payments,
      page: () => const PaymentsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PaymentsController>(() => PaymentsController());
      }),
    ),
    GetPage(
      name: AppRoutes.transactions,
      page: () => const TransactionsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TransactionsController>(() => TransactionsController());
      }),
    ),

    GetPage(name: '/login', page: () => LoginScreen(), binding: LoginBinding()),

    GetPage(
      name: '/notifications',
      page: () => const NotificationView(),

      binding: BindingsBuilder(() {
        Get.put(NotificationController());
      }),
    ),

    GetPage(
      name: '/doctor-profile',
      page: () => DoctorProfileView(),
      binding: DoctorProfileBinding(),
    ),
    GetPage(name: AppRoutes.patientQueue, page: () => const PatientQueueView(), binding: PatientQueueBinding()),
  ];
}
