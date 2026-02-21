import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _openGoogleMaps() async {
    final String urlString =
        "comgooglemaps://?saddr=$userLat,$userLng&daddr=${restaurant.lat},${restaurant.lng}&directionsmode=walking";
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      final String webUrlString =
          "https://www.google.com/maps/dir/?api=1&origin=$userLat,$userLng&destination=${restaurant.lat},${restaurant.lng}&travelmode=walking";
      await launchUrl(
        Uri.parse(webUrlString),
        mode: LaunchMode.externalApplication,
      );
    }
  }

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
      appBar: AppBar(
        title: Text(restaurant.name),
        elevation: 1,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColor.ui.gray,
      ),
      body: Column(
        children: [
          // ■ 上半分：地図エリア
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

          // ■ 下半分：詳細情報エリア
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
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
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.restaurant),
                                    ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),
                          // 右側：店名とタグ
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. 店名
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
                                      // 文字が長すぎた時のための折り返し対応
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
                                  onTap: _openGoogleMaps, // タップで関数を実行！
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.open_in_new,
                                        size: 14,
                                        color: AppColor.ui.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Googleマップで経路を見る",
                                        style: TextStyle(
                                          color: AppColor.text.secondary,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              AppColor.text.secondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12), // タグとの隙間
                                // 3. タグ
                                Wrap(
                                  spacing: 8, // タグ同士の横の隙間
                                  runSpacing: 4, // 画面端で折り返した時の縦の隙間
                                  children: restaurant.genres.map((genreText) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.pink[50],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        genreText,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColor.text.secondary,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ★ 配置は元のまま！下の情報を並べるエリア
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 情報を綺麗に並べるための補助パーツ (元のコードのまま)
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
