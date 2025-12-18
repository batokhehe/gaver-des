import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class JobEmptyCard extends StatelessWidget {
  final String type;
  final VoidCallback onTap;

  const JobEmptyCard({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.grey2,
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
                      'Tidak Ada $type Aktif',
                      style: AppTypography.smallBoldWhite,
                    ),
                    Text(
                      'Ambil tugas untuk mulai bekerja',
                      style: AppTypography.smallNormalWhite,
                    ),
                  ],
                ),
              ],
            ),
          ),
          JobActiveDetail(type: type, onTap: onTap),
        ],
      ),
    );
  }
}

class JobActiveDetail extends StatelessWidget {
  final String type;
  final VoidCallback onTap;

  const JobActiveDetail({super.key, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
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
              child: Text(
                'Ambil Tugas $type Sekarang',
                style: AppTypography.smallNormalBlack,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }
}
