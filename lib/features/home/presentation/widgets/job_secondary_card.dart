import 'package:flutter/material.dart';
import 'package:gaver_des/features/home/domain/entities/job.dart';
import '../../../../core/theme/app_text.dart';

class JobSecondaryCard extends StatelessWidget {
  final Job job;

  const JobSecondaryCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title, style: AppText.bold18),
            const SizedBox(height: 4),
            Text(job.address, style: AppText.regularGrey),
          ],
        ),
      ),
    );
  }
}
