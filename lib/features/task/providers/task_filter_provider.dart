import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskFilter { pickup, delivery }

final taskFilterProvider =
StateProvider<TaskFilter>((ref) => TaskFilter.pickup);
