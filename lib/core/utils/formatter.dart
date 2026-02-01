import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../features/task/domain/entities/task_entity.dart';

String formatDate(DateTime date) {
  final months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  return '${date.day.toString().padLeft(2, '0')} '
      '${months[date.month - 1]} '
      '${date.year}';
}

Future<String> imagePathToBase64(String path) async {
  final bytes = await File(path).readAsBytes();
  return base64Encode(bytes);
}

Map<DateTime, List<TaskEntity>> groupTasksByDate(List<TaskEntity> tasks) {
  final Map<DateTime, List<TaskEntity>> grouped = {};

  for (final task in tasks) {
    final date = DateTime(
      task.pickupDate.year,
      task.pickupDate.month,
      task.pickupDate.day,
    );
    grouped.putIfAbsent(date, () => []);
    grouped[date]!.add(task);
  }

  final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

  return {for (final key in sortedKeys) key: grouped[key]!};
}

Future<String?> pickImage({required ImageSource source}) async {
  final picker = ImagePicker();
  final file = await picker.pickImage(source: source, imageQuality: 80);
  return file?.path;
}
