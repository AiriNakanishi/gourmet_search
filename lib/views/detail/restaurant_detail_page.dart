import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:gourmet_search/views/detail/widgets/detail_header.dart';
import 'package:gourmet_search/views/detail/widgets/detail_info_section.dart';
import 'package:gourmet_search/views/detail/widgets/detail_map_view.dart';
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
          //地図
          Expanded(flex: 1, child: DetailMapView(restaurant: restaurant)),

          // ■ 下半分：詳細情報エリア
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailHeader(
                      restaurant: restaurant,
                      distanceText: distanceText,
                      walkingMinutes: walkingMinutes,
                      onOpenMap: _openGoogleMaps,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DetailInfoSection(
                            icon: Icons.location_on,
                            label: '住所',
                            content: restaurant.address,
                          ),
                          DetailInfoSection(
                            icon: Icons.access_time,
                            label: '営業時間',
                            content: restaurant.open,
                          ),
                          DetailInfoSection(
                            icon: Icons.directions_walk,
                            label: 'アクセス',
                            content: restaurant.access,
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
}
