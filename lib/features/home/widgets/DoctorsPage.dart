import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tabibi/core/constance/app_colors.dart';

import '../../../core/services/doctor_service.dart';
import '../../../features/auth/data/models/DoctorModel.dart';
import '../model/doctor_filter_options.dart';
import '../widgets/doctor_card.dart';
import '../widgets/doctor_filter_sort_sheet.dart';

class DoctorsPage extends StatefulWidget {
  final String specialityLabel;
  final String specializationValue;

  const DoctorsPage({
    super.key,
    required this.specialityLabel,
    required this.specializationValue,
  });

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final DoctorService _service = DoctorService();
  final List<DoctorModel> _doctors = [];
  Timer? _searchDebounce;
  int _searchRequestId = 0;
  String _lastSearchQuery = '';
  DoctorFilterOptions _filters = const DoctorFilterOptions.empty();
  List<String> _availableLanguages = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String rawQuery) {
    final query = rawQuery.trim();
    _searchDebounce?.cancel();
    final requestId = ++_searchRequestId;

    if (query.isEmpty) {
      _lastSearchQuery = '';
      _loadDoctors(requestId: requestId);
      return;
    }

    if (query == _lastSearchQuery) {
      return;
    }

    _lastSearchQuery = query;
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _loadDoctors(search: query, requestId: requestId);
    });
  }

  Future<void> _openFilters() async {
    final selected = await showDoctorFilterSortSheet(
      context: context,
      current: _filters,
      availableLanguages: _availableLanguages,
    );
    if (selected == null || _filters.matches(selected)) {
      return;
    }

    setState(() {
      _filters = selected;
    });
    _searchDebounce?.cancel();
    final requestId = ++_searchRequestId;
    final query = _lastSearchQuery;
    await _loadDoctors(
      search: query.isEmpty ? null : query,
      requestId: requestId,
    );
  }

  Future<void> _loadDoctors({String? search, int? requestId}) async {
    final activeRequestId = requestId ?? ++_searchRequestId;
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final rawData = await _service.getAll(
        search: search,
        specialization: widget.specializationValue,
        language: _filters.language,
        sortBy: _filters.sortBy,
        sortOrder: _filters.sortOrder,
      );
      final doctors = rawData
          .map(
            (entry) =>
                DoctorModel.fromJson(Map<String, dynamic>.from(entry as Map)),
          )
          .toList();
      if (!mounted || activeRequestId != _searchRequestId) {
        return;
      }
      setState(() {
        _doctors
          ..clear()
          ..addAll(doctors);
        if (search == null && _filters.language == null) {
          _availableLanguages = _languagesFrom(doctors);
        }
      });
    } catch (_) {
      if (!mounted || activeRequestId != _searchRequestId) {
        return;
      }
      setState(() {
        _errorMessage = 'Unable to load doctors for this speciality right now.';
      });
    } finally {
      if (mounted && activeRequestId == _searchRequestId) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _retryDoctors() async {
    _searchDebounce?.cancel();
    final requestId = ++_searchRequestId;
    final query = _lastSearchQuery;
    await _loadDoctors(
      search: query.isEmpty ? null : query,
      requestId: requestId,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primaryBlue,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.lightGray,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.specialityLabel,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(),
            const SizedBox(height: 18),
            Text(
              '${widget.specialityLabel} Doctors',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildDoctorsBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search doctors in ${widget.specialityLabel}...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 17,
                  horizontal: 20,
                ),
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'Filter & Sort',
                onPressed: _openFilters,
                icon: Icon(
                  Icons.tune_rounded,
                  color: _filters.isActive
                      ? AppColors.primaryBlue
                      : Colors.grey.shade500,
                ),
              ),
              if (_filters.isActive)
                const Positioned(
                  top: 9,
                  right: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(width: 8, height: 8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 52, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _retryDoctors,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (_doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              _lastSearchQuery.isEmpty
                  ? 'No doctors found for this speciality.'
                  : 'No doctors found in ${widget.specialityLabel}.',
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: _doctors.length,
      itemBuilder: (context, index) => DoctorCard(doc: _doctors[index]),
    );
  }
}
