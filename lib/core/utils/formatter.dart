import 'dart:convert';
import 'dart:io';

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
