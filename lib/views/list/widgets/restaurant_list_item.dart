import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:gourmet_search/models/restaurant.dart';

class RestaurantListItem extends StatelessWidget {
  final Restaurant shop;
  final double userLat;
  final double userLng;
  final VoidCallback onTap;

  const RestaurantListItem({
    super.key,
    required this.shop,
    required this.userLat,
    required this.userLng,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double distanceInMeters = Geolocator.distanceBetween(
      userLat,
      userLng,
      shop.lat,
      shop.lng,
    );

    String distanceText = distanceInMeters >= 1000
        ? "${(distanceInMeters / 1000).toStringAsFixed(1)}km"
        : "${distanceInMeters.toInt()}m";

    int walkingMinutes = (distanceInMeters / 80).ceil();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: AppColor.brand.primary,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            shop.photoImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.restaurant, size: 40),
          ),
        ),
        title: Text(
          shop.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shop.access,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColor.text.darkgray),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.directions_walk,
                  size: 16,
                  color: AppColor.ui.primary,
                ),
                Text(
                  " $distanceText (約$walkingMinutes分)",
                  style: TextStyle(
                    color: AppColor.text.gray,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
