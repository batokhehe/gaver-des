import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selected = 2; // default "Bulan Ini"
  String? selectedRangeText;

  final List<String> options = [
    "Hari ini",
    "Minggu ini",
    "Bulan Ini",
    "Rentang tanggal manual",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- TITLE ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Data",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ---- OPTIONS ----
          ...List.generate(options.length, (index) {
            final active = index == selected;

            return GestureDetector(
              onTap: () async {
                setState(() => selected = index);

                // Jika memilih Rentang Tanggal
                if (options[index] == "Rentang tanggal manual") {
                  final pickedRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    initialDateRange: DateTimeRange(
                      start:
                      DateTime.now().subtract(const Duration(days: 7)),
                      end: DateTime.now(),
                    ),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFFD55A24),
                            onPrimary: Colors.white,
                            onSurface: Colors.black87,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedRange != null) {
                    final format = DateFormat("dd MMMM yyyy");
                    final start = format.format(pickedRange.start);
                    final end = format.format(pickedRange.end);

                    setState(() {
                      selectedRangeText = "$start - $end";
                    });
                  }
                }
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active
                        ? const Color(0xFFD55A24)
                        : Colors.grey.shade300,
                  ),
                  color:
                  active ? const Color(0xFFFFF1E9) : Colors.white,
                ),
                child: Text(
                  options[index] == "Rentang tanggal manual" &&
                      selectedRangeText != null
                      ? selectedRangeText!
                      : options[index],
                  style: TextStyle(
                    fontWeight: active ? FontWeight.bold : FontWeight.w500,
                    color:
                    active ? const Color(0xFFD55A24) : Colors.black87,
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          // ---- BUTTON FILTER ----
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD55A24),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, {
                "selected": options[selected],
                "range": selectedRangeText,
              });
            },
            child: const Text(
              "Terapkan Filter",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
