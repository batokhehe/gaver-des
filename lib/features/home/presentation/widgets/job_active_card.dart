import 'package:flutter/material.dart';
import 'package:gaver_des/features/task/domain/entities/task_entity.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class JobActiveCard extends StatelessWidget {
  final TaskEntity job;
  final String type;
  final VoidCallback onOpenTask;

  const JobActiveCard({
    super.key,
    required this.job,
    required this.type,
    required this.onOpenTask,
  });

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
                // KODE + ALAMAT SINGKAT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.code,
                        style: AppTypography.smallBoldWhite,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.address,
                        style: AppTypography.smallNormalWhite,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),

                CardPickupInfo(type: type, itemCount: job.itemCount),
              ],
            ),
          ),

          JobActiveDetail(
            vendor: job.vendor,
            address: job.address,
            onOpenTask: onOpenTask,
          ),
        ],
      ),
    );
  }
}

class CardPickupInfo extends StatelessWidget {
  final String type;
  final int itemCount;

  const CardPickupInfo({
    super.key,
    required this.type,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(type, style: AppTypography.xSmallNormalWhite),
        ),
        const SizedBox(height: 4),
        Text('$itemCount Barang', style: AppTypography.xSmallNormalWhite),
      ],
    );
  }
}

class JobActiveDetail extends StatelessWidget {
  final String vendor;
  final String address;
  final VoidCallback onOpenTask;

  const JobActiveDetail({
    super.key,
    required this.vendor,
    required this.address,
    required this.onOpenTask,
  });

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor,
                  style: AppTypography.smallBoldBlack,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  address,
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
