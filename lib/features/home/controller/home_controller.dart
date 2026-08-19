import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constance/app_alerts.dart';
import '../../../core/constance/app_messages.dart';
import '../../../core/services/doctor_service.dart';
import '../../../features/auth/data/models/DoctorModel.dart';
import '../../../features/auth/data/models/LookupModel.dart';
import '../../../features/auth/repository/auth_repository.dart';
import '../model/doctor_filter_options.dart';

class HomeController extends GetxController {
  HomeController({DoctorService? doctorService})
    : _service = doctorService ?? DoctorService();

  final DoctorService _service;
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  Timer? _searchDebounce;
  int _searchRequestId = 0;
  String _lastSearchQuery = '';
  DoctorFilterOptions _doctorFilters = const DoctorFilterOptions.empty();

  final specialities = <LookupModel>[].obs;
  final topDoctors = <DoctorModel>[].obs;
  final filteredDoctors = <DoctorModel>[].obs;
  final availableDoctorLanguages = <String>[].obs;
  final isSearching = false.obs;
  final isLoading = true.obs;
  final isSpecialitiesLoading = true.obs;
  final isRefreshing = false.obs;
  final isLoggedIn = false.obs;
  final referralsCount = 0.obs;
  final doctorsErrorMessage = RxnString();
  final specialitiesErrorMessage = RxnString();

  DoctorFilterOptions get doctorFilters => _doctorFilters;
  bool get hasActiveDoctorFilters => _doctorFilters.isActive;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    loadData();
    loadSpecialities();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getString('auth_token') != null;
    if (!isLoggedIn.value) {
      referralsCount.value = 0;
    }
  }

  Future<void> handleAuthAction() async {
    if (isLoggedIn.value) {
      await _authRepository.logout();
      isLoggedIn.value = false;
      referralsCount.value = 0;
      AppAlerts.showSuccess(
        title: AppMessages.logoutTitle,
        message: AppMessages.logoutSuccess,
      );
      Get.offAllNamed('/home');
      return;
    }

    await Get.toNamed('/login');
    await checkLoginStatus();
  }

  Future<void> refreshHome() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      await checkLoginStatus();
      await Future.wait([loadData(), loadSpecialities()]);
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      doctorsErrorMessage.value = null;
      final rawData = await _service.getAll();
      final doctors = rawData
          .map(
            (entry) =>
                DoctorModel.fromJson(Map<String, dynamic>.from(entry as Map)),
          )
          .toList();
      doctors.sort(
        (first, second) => second.averageRating.compareTo(first.averageRating),
      );
      topDoctors.assignAll(doctors);
      availableDoctorLanguages.assignAll(_languagesFrom(doctors));

      if (!isSearching.value) {
        filteredDoctors.assignAll(topDoctors);
      }
    } catch (_) {
      doctorsErrorMessage.value = 'Unable to load doctors right now.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSpecialities() async {
    try {
      isSpecialitiesLoading.value = true;
      specialitiesErrorMessage.value = null;
      final data = await _authRepository.getLookupsByCategory(
        'MEDICAL_SPECIALTY',
      );
      specialities.assignAll(data.map(LookupModel.fromJson));
    } catch (_) {
      specialitiesErrorMessage.value = 'Unable to load specialities right now.';
    } finally {
      isSpecialitiesLoading.value = false;
    }
  }

  void searchDoctor(String rawQuery) {
    final query = rawQuery.trim();
    _searchDebounce?.cancel();
    final requestId = ++_searchRequestId;

    if (query.isEmpty) {
      _lastSearchQuery = '';
      if (_doctorFilters.isActive) {
        isSearching.value = true;
        _runSearch('', requestId);
        return;
      }
      isSearching.value = false;
      isLoading.value = false;
      doctorsErrorMessage.value = null;
      filteredDoctors.assignAll(topDoctors);
      return;
    }

    if (query == _lastSearchQuery) {
      return;
    }

    _lastSearchQuery = query;
    isSearching.value = true;
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(query, requestId);
    });
  }

  Future<void> applyDoctorFilters(DoctorFilterOptions filters) async {
    if (_doctorFilters.matches(filters)) {
      return;
    }
    _doctorFilters = filters;
    _searchDebounce?.cancel();
    final requestId = ++_searchRequestId;

    if (_lastSearchQuery.isEmpty && !_doctorFilters.isActive) {
      isSearching.value = false;
      isLoading.value = false;
      doctorsErrorMessage.value = null;
      filteredDoctors.assignAll(topDoctors);
      return;
    }

    isSearching.value = true;
    await _runSearch(_lastSearchQuery, requestId);
  }

  Future<void> _runSearch(String query, int requestId) async {
    try {
      isLoading.value = true;
      doctorsErrorMessage.value = null;
      final rawData = await _service.getAll(
        search: query,
        language: _doctorFilters.language,
        sortBy: _doctorFilters.sortBy,
        sortOrder: _doctorFilters.sortOrder,
      );
      if (requestId != _searchRequestId) {
        return;
      }
      filteredDoctors.assignAll(
        rawData.map(
          (entry) =>
              DoctorModel.fromJson(Map<String, dynamic>.from(entry as Map)),
        ),
      );
    } catch (_) {
      if (requestId == _searchRequestId) {
        doctorsErrorMessage.value = 'Unable to search doctors right now.';
      }
    } finally {
      if (requestId == _searchRequestId) {
        isLoading.value = false;
      }
    }
  }

  Future<void> retryDoctors() async {
    if (isSearching.value && _lastSearchQuery.isNotEmpty) {
      final requestId = ++_searchRequestId;
      await _runSearch(_lastSearchQuery, requestId);
      return;
    }
    await loadData();
  }

  List<String> _languagesFrom(Iterable<DoctorModel> doctors) {
    final languages = <String>[];
    for (final doctor in doctors) {
      for (final language in doctor.languagesSpoken) {
        if (language.isNotEmpty && !languages.contains(language)) {
          languages.add(language);
        }
      }
    }
    return languages;
  }
}
