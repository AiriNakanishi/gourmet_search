import 'package:flutter/material.dart';
import 'package:gourmet_search/constants/app_color.dart';

class RangeIndicator extends StatelessWidget {
  final int selectedRange;
  final String rangeText;
  final Function(int) onRangeChanged;

  const RangeIndicator({
    super.key,
    required this.selectedRange,
    required this.rangeText,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      top: 100,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              "範囲",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              rangeText,
              style: TextStyle(
                color: AppColor.text.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: selectedRange.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: AppColor.ui.primary,
                inactiveColor: Colors.pink[100],
                onChanged: (value) {
                  onRangeChanged(value.toInt());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
