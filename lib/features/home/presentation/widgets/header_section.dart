import 'package:flutter/material.dart';
import 'package:gaver_des/core/theme/app_colors.dart';

class HeaderSection extends StatelessWidget {
  final String header;
  final String subHeader;
  final bool isTransparent;

  const HeaderSection({
    super.key,
    required this.header,
    required this.subHeader,
    required this.isTransparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subHeader,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
