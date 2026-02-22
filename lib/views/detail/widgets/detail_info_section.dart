import 'package:flutter/material.dart';
import 'package:gourmet_search/constants/app_color.dart';

class DetailInfoSection extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String content;

  const DetailInfoSection({
    super.key,
    this.icon,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColor.brand.secondary),
            const SizedBox(width: 12),
          ] else
            const SizedBox(width: 36),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: AppColor.text.gray, fontSize: 12),
                ),
                Text(content, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
