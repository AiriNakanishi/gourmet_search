import 'package:flutter/material.dart';
import 'package:gourmet_search/constants/app_color.dart';
import '../../models/restaurant.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({super.key, required this.restaurant});

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 情報を綺麗に並べるための補助パーツ
  Widget _buildInfoSection(IconData icon, String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.brand.secondary),
          const SizedBox(width: 12),
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
