import 'package:flutter/material.dart';
import 'package:tabibi/core/constance/app_colors.dart';

class AboutTabibiView extends StatelessWidget {
  const AboutTabibiView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InformationPage(
      title: 'About Tabibi',
      intro:
          'Tabibi is a healthcare and clinic platform that helps patients find doctors, manage appointments, and keep important health information in one place.',
      sections: [
        _InformationSection(
          icon: Icons.search_rounded,
          title: 'Find the right doctor',
          body:
              'Browse doctors and specialities, search by name or speciality, apply available filters, and view doctor profiles before booking.',
        ),
        _InformationSection(
          icon: Icons.calendar_month_outlined,
          title: 'Manage appointments',
          body:
              'Choose available appointment times, view upcoming and past appointments, and use the appointment features available to your account.',
        ),
        _InformationSection(
          icon: Icons.folder_shared_outlined,
          title: 'Keep your record together',
          body:
              'Use Medical Record to manage your medical profile, visits, attachments, medicines, and profile updates.',
        ),
        _InformationSection(
          icon: Icons.favorite_border_rounded,
          title: 'Use patient tools',
          body:
              'Save favourite doctors, follow relevant queue information, and use referrals or reminders when they are available for your care.',
        ),
      ],
    );
  }
}

class GuestHelpSupportView extends StatelessWidget {
  const GuestHelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    const faqs = [
      _Faq(
        question: 'How do I book an appointment?',
        answer:
            'Open a doctor profile, choose an available clinic, date, period, and time, select the appointment type, then confirm the booking details.',
      ),
      _Faq(
        question: 'How do I cancel an appointment?',
        answer:
            'Open My Appointments and select an appointment that is eligible for cancellation. Follow the cancellation action shown for that appointment.',
      ),
      _Faq(
        question: 'Where can I find my Medical Record?',
        answer:
            'After signing in, open the Medical Record section from your patient area to access your medical profile, visits, attachments, medicines, and profile updates.',
      ),
      _Faq(
        question: 'What are Medicines?',
        answer:
            'Medicines are items in your Medical Record that help you keep track of medication information and status shared through your care record.',
      ),
      _Faq(
        question: 'How does the Queue work?',
        answer:
            'When an upcoming appointment has an active queue status, the Queue area can show the live status provided for that appointment.',
      ),
      _Faq(
        question: 'How can I favourite a doctor?',
        answer:
            'Use the heart action on an available doctor card or doctor profile. Your saved doctors are available in the Favorites section after signing in.',
      ),
      _Faq(
        question: 'How do I search, filter, or sort doctors?',
        answer:
            'Use the search field on Home to search doctors or specialities. After entering a search term, use Filter & Sort to apply the available language and ordering options.',
      ),
      _Faq(
        question: 'How do I view a doctor profile?',
        answer:
            'Tap a doctor card from Home, search results, a speciality list, or Favorites to open the available doctor profile.',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _informationAppBar(context, 'Help & Support'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          const Text(
            'Frequently asked questions',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find quick guidance for features currently available in Tabibi.',
            style: TextStyle(color: Colors.black54, height: 1.45),
          ),
          const SizedBox(height: 18),
          ...faqs.map(
            (faq) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ExpansionTile(
                title: Text(
                  faq.question,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                iconColor: AppColors.primaryBlue,
                collapsedIconColor: AppColors.primaryBlue,
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(
                    faq.answer,
                    style: const TextStyle(color: Colors.black54, height: 1.45),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InformationPage(
      title: 'Privacy Policy',
      intro:
          'This is a simple informational overview of the information used in the current Tabibi application. It is not a complete legal policy.',
      sections: [
        _InformationSection(
          icon: Icons.person_outline_rounded,
          title: 'Information used in your account',
          body:
              'The app can use account, contact, and profile information that you provide while creating or managing your patient account.',
        ),
        _InformationSection(
          icon: Icons.medical_information_outlined,
          title: 'Health and care information',
          body:
              'Your patient experience may include medical profile information, appointments, visit information, medicines, and record attachments that are entered or made available through the app.',
        ),
        _InformationSection(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Service information',
          body:
              'Where available in your account, the app can display wallet, payment, or transaction-related information connected with clinic services.',
        ),
        _InformationSection(
          icon: Icons.lock_outline_rounded,
          title: 'Access in the application',
          body:
              'Access to profile and medical information is managed through the application’s existing user roles and permission controls. Keep your account credentials private and use the app on trusted devices.',
        ),
      ],
    );
  }
}

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InformationPage(
      title: 'Terms & Conditions',
      intro:
          'This is a concise, informational summary for the current Tabibi application. It is not a complete legal agreement.',
      sections: [
        _InformationSection(
          icon: Icons.manage_accounts_outlined,
          title: 'Your account',
          body:
              'Use accurate account and profile information, protect your sign-in credentials, and do not use another person’s account or services without permission.',
        ),
        _InformationSection(
          icon: Icons.event_available_outlined,
          title: 'Appointments and clinic services',
          body:
              'Appointment availability, booking, confirmation, cancellation, referrals, and queue information are shown through the services available to your account and clinic.',
        ),
        _InformationSection(
          icon: Icons.payments_outlined,
          title: 'Payments where available',
          body:
              'If wallet, payment, or transaction features are available to your account, review the information displayed for your clinic service before completing an action.',
        ),
        _InformationSection(
          icon: Icons.health_and_safety_outlined,
          title: 'Appropriate use',
          body:
              'Use health information and record features responsibly. Medical care, diagnoses, treatment decisions, and clinical advice are provided by the relevant healthcare professionals and clinics.',
        ),
      ],
    );
  }
}

class _InformationPage extends StatelessWidget {
  final String title;
  final String intro;
  final List<_InformationSection> sections;

  const _InformationPage({
    required this.title,
    required this.intro,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: _informationAppBar(context, title),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          Text(
            intro,
            style: const TextStyle(color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 20),
          ...sections.map(
            (section) => Card(
              margin: const EdgeInsets.only(bottom: 14),
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(section.icon, color: AppColors.primaryBlue),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            section.body,
                            style: const TextStyle(
                              color: Colors.black54,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

AppBar _informationAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: AppColors.lightGray,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.primaryBlue,
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: AppColors.primaryBlue,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    ),
    centerTitle: true,
  );
}

class _InformationSection {
  final IconData icon;
  final String title;
  final String body;

  const _InformationSection({
    required this.icon,
    required this.title,
    required this.body,
  });
}

class _Faq {
  final String question;
  final String answer;

  const _Faq({required this.question, required this.answer});
}
