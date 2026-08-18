class DoctorFilterOptions {
  static const rating = 'averageRating';
  static const experience = 'experienceYears';
  static const ascending = 'asc';
  static const descending = 'desc';

  final String? language;
  final String? sortBy;
  final String? sortOrder;

  const DoctorFilterOptions({this.language, this.sortBy, this.sortOrder});

  const DoctorFilterOptions.empty()
    : language = null,
      sortBy = null,
      sortOrder = null;

  bool get isActive => language != null || sortBy != null || sortOrder != null;

  bool matches(DoctorFilterOptions other) {
    return language == other.language &&
        sortBy == other.sortBy &&
        sortOrder == other.sortOrder;
  }
}
