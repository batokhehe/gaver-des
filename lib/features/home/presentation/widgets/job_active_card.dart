import 'package:flutter/material.dart';
import 'package:gaver_des/features/home/domain/entities/job.dart';
import 'package:gaver_des/features/home/presentation/widgets/task_info_bottom_sheet.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../views/home_page.dart';

class JobActiveCard extends StatelessWidget {
  const JobActiveCard({super.key, required Job? job, required this.onOpenTask});

  final VoidCallback onOpenTask;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PKO.2025.11.0001',
                      style: AppTypography.smallBoldWhite,
                    ),
                    Text(
                      'Jl. Melati No. 12, Jakarta Timur ',
                      style: AppTypography.smallNormalWhite,
                    ),
                  ],
                ),
                CardPickupInfo(),
              ],
            ),
          ),
          JobActiveDetail(onOpenTask: onOpenTask),
        ],
      ),
    );
  }
}

class CardPickupInfo extends StatelessWidget {
  const CardPickupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Pick Up', style: AppTypography.xSmallNormalWhite),
        ),
        const SizedBox(height: 2),
        const Text('20 Barang', style: AppTypography.xSmallNormalWhite),
      ],
    );
  }
}

class JobActiveDetail extends StatelessWidget {
  final VoidCallback onOpenTask;

  const JobActiveDetail({super.key, required this.onOpenTask});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PT. Sinar Logistik Nusantara',
                  style: AppTypography.smallBoldBlack,
                ),
                SizedBox(height: 4),
                Text(
                  'Jl. Gatot Subroto Blok B3 No. 12, Jakarta Selatan',
                  style: AppTypography.smallNormalBlack,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onOpenTask,
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
