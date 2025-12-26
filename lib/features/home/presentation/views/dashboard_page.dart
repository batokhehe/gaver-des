import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/tab_index_provider.dart';
import '../../../task/providers/task_viewmodel.dart';
import '../../../user/providers/user_provider.dart';
import '../../../user/providers/user_repository_provider.dart';
import '../widgets/daily_recap_section.dart';
import '../widgets/header_section.dart';
import '../widgets/job_active_card.dart';
import '../widgets/job_empty_card.dart';
import '../widgets/task_info_bottom_sheet.dart';
import '../widgets/vehicle_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasActiveJob = true;
    final fullName = ref.watch(userNameProvider);
    final email = ref.watch(userEmailProvider);
    final vehicle = ref.watch(userVehicleProvider);

    final dashboardAsync = ref.watch(taskDashboardResponseProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(userRepositoryProvider).fetchUserFromApi();
          await ref.refresh(userProvider.future);
          await ref.refresh(taskDashboardResponseProvider.future);
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
                    subHeader: dashboardAsync.when(
                      loading: () => 'Memuat tugas hari ini...',
                      error: (_, __) => 'Gagal memuat tugas',
                      data: (res) {
                        final count = res.totalData;
                        if (count == 0) {
                          return 'Anda belum memiliki tugas aktif hari ini';
                        }
                        return 'Anda memiliki $count tugas aktif hari ini';
                      },
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.greyBg,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Pekerjaan Aktif"),
                      dashboardAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(height: 120),
                        ),
                        error: (_, __) => JobEmptyCard(
                          type: 'Pick Up',
                          onTap: () {
                            ref.read(tabIndexProvider.notifier).state = 1;
                          },
                        ),
                        data: (tasks) {
                          if (tasks.totalData == 0) {
                            return JobEmptyCard(
                              type: 'Pick Up',
                              onTap: () {
                                ref.read(tabIndexProvider.notifier).state = 1;
                              },
                            );
                          }
                          return JobActiveCard(
                            job: tasks.data.first,
                            type: 'Pick Up',
                            onOpenTask: () {
                              context.push(
                                '/pickup-form/${tasks.data.first.id}',
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      JobEmptyCard(
                        type: 'Delivery',
                        onTap: () {
                          ref.read(tabIndexProvider.notifier).state = 1;
                        },
                      ),
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
    child: Text(text, style: AppTypography.mediumBoldBlack),
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
