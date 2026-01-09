import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/theme/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selected = 2;
  String? selectedRangeText;
  DateTime? _startDate;
  DateTime? _endDate;

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
              Text("Filter Data", style: AppTypography.mediumBoldBlack),
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

                if (options[index] == "Rentang tanggal manual") {
                  final pickedRange = await showFancyDateRangePicker(context);

                  if (pickedRange != null) {
                    _startDate = pickedRange.start;
                    _endDate = pickedRange.end;

                    final format = DateFormat("dd MMMM yyyy");
                    setState(() {
                      selectedRangeText =
                          "${format.format(_startDate!)} - ${format.format(_endDate!)}";
                    });
                  }
                } else {
                  setState(() {
                    _setDateRangeByOption(index);
                  });
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
                    color: active ? AppColors.primary : Colors.grey.shade300,
                  ),
                  color: active ? const Color(0xFFFFF1E9) : Colors.white,
                ),
                child: Text(
                  options[index] == "Rentang tanggal manual" &&
                          selectedRangeText != null
                      ? selectedRangeText!
                      : options[index],
                  style: TextStyle(
                    fontWeight: active ? FontWeight.bold : FontWeight.w500,
                    color: active ? AppColors.primary : Colors.black87,
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          // ---- BUTTON FILTER ----
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, {
                "selected": options[selected],
                "startDate": _startDate,
                "endDate": _endDate,
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

  void _setDateRangeByOption(int index) {
    final now = DateTime.now();

    switch (options[index]) {
      case "Hari ini":
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
        selectedRangeText = DateFormat("dd MMMM yyyy").format(now);
        break;

      case "Minggu ini":
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));

        _startDate = DateTime(
          startOfWeek.year,
          startOfWeek.month,
          startOfWeek.day,
        );
        _endDate = DateTime(
          endOfWeek.year,
          endOfWeek.month,
          endOfWeek.day,
          23,
          59,
          59,
        );

        selectedRangeText =
            "${DateFormat("dd MMM").format(_startDate!)} - "
            "${DateFormat("dd MMM yyyy").format(_endDate!)}";
        break;

      case "Bulan Ini":
        final startOfMonth = DateTime(now.year, now.month, 1);
        final endOfMonth = DateTime(now.year, now.month + 1, 0);

        _startDate = startOfMonth;
        _endDate = DateTime(
          endOfMonth.year,
          endOfMonth.month,
          endOfMonth.day,
          23,
          59,
          59,
        );

        selectedRangeText = DateFormat("MMMM yyyy").format(now);
        break;
    }
  }

  Future<DateTimeRange?> showDateRangeBottomSheet(BuildContext context) async {
    DateTimeRange? tempRange;

    return await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        DateTime? start;
        DateTime? end;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Pilih Rentang Tanggal",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    onDateChanged: (date) {
                      if (start == null || (start != null && end != null)) {
                        start = date;
                        end = null;
                      } else {
                        end = date.isAfter(start!) ? date : start;
                        start = date.isBefore(start!) ? date : start;
                      }

                      setState(() {
                        if (start != null && end != null) {
                          tempRange = DateTimeRange(start: start!, end: end!);
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: tempRange == null
                        ? null
                        : () => Navigator.pop(context, tempRange),
                    child: const Text("Terapkan"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<DateTimeRange?> showFancyDateRangePicker(BuildContext context) async {
    DateTime? startDate;
    DateTime? endDate;

    return await showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            String headerDateText() {
              if (startDate == null) return "Select Date";
              return DateFormat("EEE, MMM d").format(startDate!);
            }

            return Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select date",
                      style: AppTypography.smallBoldBlack,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          headerDateText(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// ───── CALENDAR ─────
                  SfDateRangePicker(
                    selectionMode: DateRangePickerSelectionMode.range,
                    backgroundColor: AppColors.white,
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: AppTypography.mediumBoldBlack,
                      backgroundColor: AppColors.white,
                    ),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                    ),
                    selectionColor: AppColors.primary,
                    todayHighlightColor: AppColors.primary,
                    rangeSelectionColor: AppColors.primaryShade,
                    startRangeSelectionColor: AppColors.primary,
                    endRangeSelectionColor: AppColors.primary,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                          if (args.value is PickerDateRange) {
                            setState(() {
                              startDate = args.value.startDate;
                              endDate = args.value.endDate;
                            });
                          }
                        },
                  ),

                  const SizedBox(height: 12),

                  /// ───── FOOTER BUTTONS ─────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            startDate = null;
                            endDate = null;
                          });
                        },
                        child: Text(
                          "Hapus",
                          style: AppTypography.xSmallBoldPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Batalkan",
                              style: AppTypography.xSmallBoldPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: startDate == null
                                ? null
                                : () {
                                    Navigator.pop(
                                      context,
                                      DateTimeRange(
                                        start: startDate!,
                                        end: endDate ?? startDate!,
                                      ),
                                    );
                                  },
                            child: Text(
                              "OK",
                              style: AppTypography.xSmallBoldPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
