import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';

import '../../../pick_up/presentation/views/pick_up_form_page.dart';

class TaskCard extends StatelessWidget {
  final int id;
  final String code;
  final String hub;
  final String status;
  final Color statusColor;
  final int item;
  final String vendor;
  final String address;
  final bool isShowBottomNext;
  final bool isHistory;

  const TaskCard({
    super.key,
    required this.id,
    required this.code,
    required this.hub,
    required this.status,
    required this.statusColor,
    required this.item,
    required this.vendor,
    required this.address,
    required this.isShowBottomNext,
    required this.isHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.inactiveBorder,
                        shape: BoxShape.circle,
                      ),
                      child: isHistory
                          ? Image.asset(
                              "assets/icons/ic_box_check.png",
                              width: 35,
                              height: 35,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              "assets/icons/ic_box_time.png",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(code, style: AppTypography.smallBoldBlack),
                    Text(hub, style: AppTypography.smallNormalBlack),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Pick up", style: AppTypography.xSmallBoldPrimary),
                  Text("$item Barang", style: AppTypography.xSmallNormalBlack),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.black12, thickness: 1, height: 16),
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.inactiveBorder,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "assets/icons/ic_location.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vendor, style: AppTypography.smallBoldBlack),
                    Text(address, style: AppTypography.smallNormalBlack),
                  ],
                ),
              ),
              isShowBottomNext
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            context.push(
                              '/pickup-detail/$id?history=$isHistory',
                            );
                          },
                          child: Image.asset(
                            "assets/icons/ic_arrow_forward.png",
                            width: 42,
                            height: 42,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
