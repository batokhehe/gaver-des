import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';
import 'package:gaver_des/core/theme/app_typography.dart';

class ItemCard extends StatelessWidget {
  final String code;
  final String name;
  final String status;
  final Color statusColor;
  final String total;
  final String weight;

  const ItemCard({
    super.key,
    required this.code,
    required this.name,
    required this.status,
    required this.statusColor,
    required this.total,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
                      child: Image.asset(
                        "assets/icons/ic_box_time.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(code, style: AppTypography.smallBoldBlack),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: total,
                            style: AppTypography.xSmallNormalGrey,
                          ),
                          const WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                " • ",
                                style: AppTypography.xSmallNormalGrey,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: weight,
                            style: AppTypography.xSmallNormalGrey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
