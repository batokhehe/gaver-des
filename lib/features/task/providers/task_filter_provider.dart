import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskFilter { pickup, delivery }

final taskFilterProvider = StateProvider<TaskFilter>(
  (ref) => TaskFilter.pickup,
);

class DateFilter {
  final DateTime? startDate;
  final DateTime? endDate;

  const DateFilter({this.startDate, this.endDate});

  bool get isActive => startDate != null && endDate != null;

  DateFilter copyWith({DateTime? startDate, DateTime? endDate}) {
    return DateFilter(startDate: startDate, endDate: endDate);
  }
}

final taskDateFilterProvider = StateProvider<DateFilter>(
  (ref) => const DateFilter(),
);
