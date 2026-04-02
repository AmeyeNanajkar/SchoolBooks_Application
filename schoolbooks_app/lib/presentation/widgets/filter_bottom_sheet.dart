import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? selectedBoard;
  final String? selectedGrade;
  final String? selectedSubject;
  final List<String> boards;
  final List<String> grades;
  final List<String> subjects;
  final Function(String?, String?, String?) onApply;
  final VoidCallback onClear;

  const FilterBottomSheet({
    super.key,
    this.selectedBoard,
    this.selectedGrade,
    this.selectedSubject,
    required this.boards,
    required this.grades,
    required this.subjects,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _board;
  String? _grade;
  String? _subject;

  @override
  void initState() {
    super.initState();
    _board = widget.selectedBoard;
    _grade = widget.selectedGrade;
    _subject = widget.selectedSubject;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Books',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      'Board',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.boards.map((board) {
                        final isSelected = _board == board;
                        return FilterChip(
                          label: Text(board),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _board = selected ? board : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Grade',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.grades.map((grade) {
                        final isSelected = _grade == grade;
                        return FilterChip(
                          label: Text(grade),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _grade = selected ? grade : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Subject',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.subjects.map((subject) {
                        final isSelected = _subject == subject;
                        return FilterChip(
                          label: Text(subject),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _subject = selected ? subject : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _board = null;
                          _grade = null;
                          _subject = null;
                        });
                        widget.onClear();
                      },
                      child: const Text('Clear All'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => widget.onApply(_board, _grade, _subject),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
