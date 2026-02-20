import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_search/constants/app_color.dart';
import '../../models/restaurant.dart';

class RestaurantDetailPage extends StatelessWidget {
  final Restaurant restaurant;
  final String distanceText;
  final int walkingMinutes;
  final double userLat;
  final double userLng;

  const RestaurantDetailPage({
    super.key,
    required this.restaurant,
    required this.distanceText,
    required this.walkingMinutes,
    required this.userLat,
    required this.userLng,
  });

  @override
  Widget build(BuildContext context) {
    double distanceInMeters = Geolocator.distanceBetween(
      userLat,
      userLng,
      restaurant.lat,
      restaurant.lng,
    );
    String distanceText = distanceInMeters >= 1000
        ? "${(distanceInMeters / 1000).toStringAsFixed(1)}km"
        : "${distanceInMeters.toInt()}m";
    int walkingMinutes = (distanceInMeters / 80).ceil();

    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(restaurant.lat, restaurant.lng), // お店が中心
                    zoom: 14.0, // 一覧より少しズームして詳細を見やすく
                  ),
                  // お店のピンを1つだけ立てる
                  markers: {
                    Marker(
                      markerId: MarkerId(restaurant.id),
                      position: LatLng(restaurant.lat, restaurant.lng),
                      infoWindow: InfoWindow(title: restaurant.name),
                    ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: SingleChildScrollView(
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
                        _buildInfoSection(
                          Icons.access_time,
                          '営業時間',
                          restaurant.open,
                        ),
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
          ),
        ],
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
