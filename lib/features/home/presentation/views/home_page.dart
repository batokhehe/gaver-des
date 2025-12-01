import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_typography.dart';

import '../widgets/bottom_nav.dart';
import '../widgets/daily_recap_section.dart';
import '../widgets/header_section.dart';
import '../widgets/job_active_card.dart';
import '../widgets/job_empty_card.dart';
import '../widgets/vehicle_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasActiveJob = true;

    return Scaffold(
      body: SingleChildScrollView(
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

                const HeaderSection(
                  userName: "Aditya Putra Rizki",
                  isTransparent: true,
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
                        ? JobActiveCard(job: null)
                        : const JobEmptyCard(),
                    const SizedBox(height: 16),

                    const JobEmptyCard(),
                    const SizedBox(height: 16),

                    sectionTitle("Rekap Harian"),
                    const DailyRecapSection(),

                    sectionTitle("Kendaraan Aktif"),
                    const VehicleCard(vehicleName: "B 1454 AC"),
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
