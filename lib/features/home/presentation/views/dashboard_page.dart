import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/tab_index_provider.dart';
import '../../../profile/data/driver_status.dart';
import '../../../task/providers/task_filter_provider.dart';
import '../../../task/providers/task_viewmodel.dart';
import '../../../user/providers/user_provider.dart';
import '../../../user/providers/user_repository_provider.dart';
import '../../dashboard_provider.dart';
import '../widgets/daily_recap_section.dart';
import '../widgets/header_section.dart';
import '../widgets/job_active_card.dart';
import '../widgets/job_empty_card.dart';
import '../widgets/task_info_bottom_sheet.dart';
import '../widgets/vehicle_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late final ProviderSubscription<int> _tabListener;

  @override
  void initState() {
    super.initState();

    _tabListener = ref.listenManual<int>(tabIndexProvider, (previous, next) {
      if (previous != next && next == 0) {
        _refreshDashboard();
      }
    });
  }

  @override
  void dispose() {
    _tabListener.close();
    super.dispose();
  }

  Future<void> _refreshDashboard() async {
    await ref.read(userRepositoryProvider).fetchUserFromApi();
    ref.invalidate(userProvider);
    ref.invalidate(taskAllResponseProvider);
    ref.invalidate(pickUpDashboardResponseProvider);
    ref.refresh(deliveryDashboardResponseProvider);
    ref.invalidate(taskDashboardSummaryProvider);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasActiveJob = true;
    final fullName = ref.watch(userNameProvider);
    final email = ref.watch(userEmailProvider);
    final vehicle = ref.watch(userVehicleProvider);

    final user = ref.watch(userProvider).value;
    final statusType = parseDriverStatus(user?.status);
    final driverStatus = mapDriverStatus(statusType);

    final pickUpDashboardAsync = ref.watch(pickUpDashboardResponseProvider);
    final deliveryDashboardAsync = ref.watch(deliveryDashboardResponseProvider);
    final summary = ref.watch(taskDashboardSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: RefreshIndicator(
        onRefresh: () async {
          await _refreshDashboard();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  subHeader: summary.when(
                    loading: () => 'Memuat tugas hari ini...',
                    error: (error, _) => 'Anda belum mendapatkan penugasan kembali untuk hari ini',
                    data: (s) => s.assigned == 0
                        ? 'Anda belum mendapatkan penugasan kembali untuk hari ini'
                        : 'Anda memiliki ${s.assigned} tugas hari ini yang belum terselesaikan',
                  ),
                  status: driverStatus,
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
                    pickUpDashboardAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(height: 120),
                      ),
                      error: (_, __) => JobEmptyCard(
                        type: 'Pick Up',
                        onTap: () {
                          ref.read(taskFilterProvider.notifier).state =
                              TaskFilter.pickup;
                          ref.read(tabIndexProvider.notifier).state = 1;
                        },
                      ),
                      data: (tasks) {
                        if (tasks.totalData == 0) {
                          return JobEmptyCard(
                            type: 'Pick Up',
                            onTap: () {
                              ref.read(taskFilterProvider.notifier).state =
                                  TaskFilter.pickup;
                              ref.read(tabIndexProvider.notifier).state = 1;
                            },
                          );
                        }
                        return JobActiveCard(
                          job: tasks.data.first,
                          type: 'Pick Up',
                          onOpenTask: () {
                            context.push('/pickup-form/${tasks.data.first.id}');
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    deliveryDashboardAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(height: 120),
                      ),
                      error: (_, __) => JobEmptyCard(
                        type: 'Delivery',
                        onTap: () {
                          ref.read(taskFilterProvider.notifier).state =
                              TaskFilter.delivery;
                          ref.read(tabIndexProvider.notifier).state = 1;
                        },
                      ),
                      data: (tasks) {
                        if (tasks.totalData == 0) {
                          return JobEmptyCard(
                            type: 'Delivery',
                            onTap: () {
                              ref.read(taskFilterProvider.notifier).state =
                                  TaskFilter.delivery;
                              ref.read(tabIndexProvider.notifier).state = 1;
                            },
                          );
                        }
                        return JobActiveCard(
                          job: tasks.data.first,
                          type: 'Delivery',
                          onOpenTask: () {
                            context.push(
                              '/delivery-form/${tasks.data.first.id}',
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    sectionTitle("Rekap Harian"),
                    const DailyRecapSection(),

                    sectionTitle("Kendaraan Aktif"),
                    VehicleCard(vehicle: vehicle),
                  ],
                ),
              ),
            ),
          ],
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
