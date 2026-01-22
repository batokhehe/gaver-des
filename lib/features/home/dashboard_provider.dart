import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../task/providers/task_viewmodel.dart';
import 'data/models/task_dashboard_summary.dart';

final taskDashboardSummaryProvider =
    FutureProvider.autoDispose<TaskDashboardSummary>((ref) async {
      final res = await ref.watch(taskAllResponseProvider.future);

      final assigned = res.data.where((e) => e.status == 'assigned').length;
      final finished = res.data.where((e) => e.status == 'finished').length;
      final canceled = res.data.where((e) => e.status == 'canceled').length;

      debugPrint('assigned: $assigned');
      debugPrint('finished: $finished');

      return TaskDashboardSummary(
        assigned: assigned,
        finished: finished,
        canceled: canceled,
      );
    });
