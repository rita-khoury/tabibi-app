import 'package:flutter/material.dart';

import '../../../core/constance/app_colors.dart';
import '../model/doctor_filter_options.dart';

Future<DoctorFilterOptions?> showDoctorFilterSortSheet({
  required BuildContext context,
  required DoctorFilterOptions current,
  required List<String> availableLanguages,
}) {
  return showModalBottomSheet<DoctorFilterOptions>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _DoctorFilterSortSheet(
      current: current,
      availableLanguages: availableLanguages,
    ),
  );
}

class _DoctorFilterSortSheet extends StatefulWidget {
  final DoctorFilterOptions current;
  final List<String> availableLanguages;

  const _DoctorFilterSortSheet({
    required this.current,
    required this.availableLanguages,
  });

  @override
  State<_DoctorFilterSortSheet> createState() => _DoctorFilterSortSheetState();
}

class _DoctorFilterSortSheetState extends State<_DoctorFilterSortSheet> {
  late String? _language;
  late String? _sortBy;
  late String? _sortOrder;

  @override
  void initState() {
    super.initState();
    _language = widget.current.language;
    _sortBy = widget.current.sortBy;
    _sortOrder = widget.current.sortOrder;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final orderOptions = _sortBy == null
        ? const <_FilterChoice>[]
        : _sortBy == DoctorFilterOptions.rating
        ? const [
            _FilterChoice(
              value: DoctorFilterOptions.descending,
              label: 'Highest to Lowest',
            ),
            _FilterChoice(
              value: DoctorFilterOptions.ascending,
              label: 'Lowest to Highest',
            ),
          ]
        : const [
            _FilterChoice(
              value: DoctorFilterOptions.descending,
              label: 'Most Experience',
            ),
            _FilterChoice(
              value: DoctorFilterOptions.ascending,
              label: 'Least Experience',
            ),
          ];

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        padding: EdgeInsets.fromLTRB(20, 14, 20, 20 + bottomInset),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.tune_rounded, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Filter & Sort',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FilterSectionTitle('Sort by'),
                    const SizedBox(height: 8),
                    _OptionTile(
                      label: 'Rating',
                      selected: _sortBy == DoctorFilterOptions.rating,
                      onTap: () => setState(() {
                        _sortBy = DoctorFilterOptions.rating;
                        _sortOrder ??= DoctorFilterOptions.descending;
                      }),
                    ),
                    _OptionTile(
                      label: 'Experience',
                      selected: _sortBy == DoctorFilterOptions.experience,
                      onTap: () => setState(() {
                        _sortBy = DoctorFilterOptions.experience;
                        _sortOrder ??= DoctorFilterOptions.descending;
                      }),
                    ),
                    const SizedBox(height: 18),
                    const _FilterSectionTitle('Sort order'),
                    const SizedBox(height: 8),
                    if (orderOptions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Choose Rating or Experience first.',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    else
                      ...orderOptions.map(
                        (option) => _OptionTile(
                          label: option.label,
                          selected: _sortOrder == option.value,
                          onTap: () => setState(() {
                            _sortOrder = option.value;
                          }),
                        ),
                      ),
                    const SizedBox(height: 18),
                    const _FilterSectionTitle('Language'),
                    const SizedBox(height: 10),
                    if (widget.availableLanguages.isEmpty)
                      Text(
                        'No doctor languages are available to filter yet.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.availableLanguages
                            .map(
                              (language) => ChoiceChip(
                                label: Text(language),
                                selected: _language == language,
                                selectedColor: AppColors.primaryBlue.withValues(
                                  alpha: 0.15,
                                ),
                                labelStyle: TextStyle(
                                  color: _language == language
                                      ? AppColors.primaryBlue
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: _language == language
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                                onSelected: (selected) => setState(() {
                                  _language = selected ? language : null;
                                }),
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop(const DoctorFilterOptions.empty()),
                  child: const Text('Clear filters'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(
                    DoctorFilterOptions(
                      language: _language,
                      sortBy: _sortBy,
                      sortOrder: _sortBy == null ? null : _sortOrder,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSectionTitle extends StatelessWidget {
  final String text;

  const _FilterSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected
                  ? AppColors.primaryBlue
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChoice {
  final String value;
  final String label;

  const _FilterChoice({required this.value, required this.label});
}
