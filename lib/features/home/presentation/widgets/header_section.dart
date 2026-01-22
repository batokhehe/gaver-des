import 'package:flutter/material.dart';

import '../../../profile/data/driver_status.dart';

class HeaderSection extends StatelessWidget {
  final String header;
  final String subHeader;
  final bool isTransparent;
  final DriverStatus status;

  const HeaderSection({
    super.key,
    required this.header,
    required this.subHeader,
    required this.isTransparent,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= LEFT TEXT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subHeader,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ================= STATUS BADGE =================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status.bgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  status.label,
                  style: TextStyle(
                    color: status.textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  status.label == 'Aktif' ? Icons.check_circle : Icons.warning,
                  size: 14,
                  color: status.textColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
