class TaskDashboardSummary {
  final int assigned;
  final int finished;
  final int canceled;

  const TaskDashboardSummary({
    required this.assigned,
    required this.finished,
    required this.canceled,
  });

  int get total => assigned + finished + canceled;

  bool get hasActive => assigned > 0;
}
