import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  DateTimeRange? selectedRange;

  String formatRange(DateTimeRange range) {
    final df = DateFormat("dd MMMM yyyy");
    return "${df.format(range.start)} - ${df.format(range.end)}";
  }

  Future<void> pickDateRange() async {
    final DateTimeRange? picked = await showCustomDateRangePicker(context);

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Filter Data",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.close),
            ],
          ),

          const SizedBox(height: 20),

          _filterButton("Hari ini", () {}),
          _filterButton("Minggu ini", () {}),
          _filterButton("Bulan Ini", () {}),

          // RENTANG MANUAL
          GestureDetector(
            onTap: pickDateRange,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedRange != null
                      ? Colors.orange
                      : Colors.grey.shade300,
                ),
                color: selectedRange != null
                    ? Colors.orange.withOpacity(0.12)
                    : Colors.white,
              ),
              child: Text(
                selectedRange != null
                    ? formatRange(selectedRange!)
                    : "Rentang tanggal manual",
                style: TextStyle(
                  color: selectedRange != null ? Colors.orange : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Button Apply
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // TODO: apply filter
                Navigator.pop(context);
              },
              child: const Text(
                "Terapkan Filter",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable filter button
  Widget _filterButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Future<DateTimeRange?> showCustomDateRangePicker(BuildContext context) async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 3)),
      ),

      // ====== BAGIAN CUSTOM UI DATE PICKER ======
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD55A24), // customize primary color
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFD55A24), // warna tombol footer
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: child!,
          ),
        );
      },
    );
  }
}
