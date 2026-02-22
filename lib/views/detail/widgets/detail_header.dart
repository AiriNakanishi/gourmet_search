import 'package:flutter/material.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:gourmet_search/models/restaurant.dart';

class DetailHeader extends StatelessWidget {
  final Restaurant restaurant;
  final String distanceText;
  final int walkingMinutes;
  final VoidCallback onOpenMap;

  const DetailHeader({
    super.key,
    required this.restaurant,
    required this.distanceText,
    required this.walkingMinutes,
    required this.onOpenMap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                restaurant.photoImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.restaurant),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk,
                      size: 16,
                      color: AppColor.ui.primary,
                    ),
                    Expanded(
                      child: Text(
                        " $distanceText (約$walkingMinutes分)",
                        style: TextStyle(
                          color: AppColor.text.darkgray,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onOpenMap,
                  child: Row(
                    children: [
                      Icon(
                        Icons.open_in_new,
                        size: 14,
                        color: AppColor.ui.primary,
                      ),
                      Text(
                        "Googleマップで経路を見る",
                        style: TextStyle(
                          color: AppColor.text.secondary,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.text.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: restaurant.genres
                      .map(
                        (genre) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            genre,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColor.text.secondary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
