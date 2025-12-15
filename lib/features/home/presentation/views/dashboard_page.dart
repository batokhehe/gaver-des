import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_typography.dart';

import '../../../user/providers/user_provider.dart';
import '../../../user/providers/user_repository_provider.dart';
import '../widgets/daily_recap_section.dart';
import '../widgets/header_section.dart';
import '../widgets/job_active_card.dart';
import '../widgets/job_empty_card.dart';
import '../widgets/task_info_bottom_sheet.dart';
import '../widgets/vehicle_card.dart';

class DashboardPage extends ConsumerWidget {
  final VoidCallback onGoToTask;

  const DashboardPage({super.key, required this.onGoToTask});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasActiveJob = true;
    final fullName = ref.watch(userNameProvider);
    final email = ref.watch(userEmailProvider);
    final vehicle = ref.watch(userVehicleProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(userRepositoryProvider).fetchUserFromApi();
          await ref.refresh(userProvider.future);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/bg_header.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  HeaderSection(
                    header: fullName,
                    isTransparent: true,
                    subHeader: 'Anda memiliki 1 tugas aktif hari ini',
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Pekerjaan Aktif"),
                      hasActiveJob
                          ? JobActiveCard(
                              job: null,
                              onOpenTask: () {
                                _showTaskInfoDialog(context, onGoToTask);
                              },
                            )
                          : const JobEmptyCard(),
                      const SizedBox(height: 16),

                      const JobEmptyCard(),
                      const SizedBox(height: 16),

                      sectionTitle("Rekap Harian"),
                      const DailyRecapSection(),

                      sectionTitle("Kendaraan Aktif"),
                      VehicleCard(
                        vehicleName:
                            vehicle?.vehicleIdentificationNumber ?? "-",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.04)),
        ],
      ),
      child: Text(text, style: AppTypography.mediumBoldBlack),
    ),
  );
}

void _showTaskInfoDialog(BuildContext context, VoidCallback onGoToTask) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) {
      return TaskInfoBottomSheet(
        onGoToTask: () async {
          Navigator.pop(bottomSheetContext);
          await Future.delayed(const Duration(milliseconds: 100));
          onGoToTask();
        },
      );
    },
  );
}
