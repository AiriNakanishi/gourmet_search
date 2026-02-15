import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_search/constants/app_color.dart';
import '../../models/restaurant.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;
  final String distanceText;
  final int walkingMinutes;

  const RestaurantDetailPage({
    super.key,
    required this.restaurant,
    required this.distanceText,
    required this.walkingMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 大きな店舗画像
            Image.network(
              restaurant.photoImage,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoSection(
                    Icons.location_on,
                    '住所',
                    restaurant.address,
                  ),
                  _buildInfoSection(Icons.access_time, '営業時間', restaurant.open),
                  _buildInfoSection(
                    Icons.directions_walk,
                    'アクセス',
                    restaurant.access,
                  ),
                  _buildInfoSection(
                    null,
                    '距離・時間',
                    '現在地から $distanceText (徒歩約$walkingMinutes分)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 情報を綺麗に並べるための補助パーツ
  Widget _buildInfoSection(IconData? icon, String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColor.brand.secondary),
            const SizedBox(width: 12),
          ] else
            // アイコンがないなら、同じサイズ(24)の「透明な箱」を置いて場所取りする
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
