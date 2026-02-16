import 'package:flutter/material.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_search/views/detail/restaurant_detail_page.dart';
import '../../models/restaurant.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantListPage extends StatefulWidget {
  final List<Restaurant> restaurants;
  final double userLat;
  final double userLng;

  const RestaurantListPage({
    super.key,
    required this.restaurants,
    required this.userLat,
    required this.userLng,
  });

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  GoogleMapController? _mapController;

  // ピン（マーカー）のリストを作る関数
  Set<Marker> _createMarkers() {
    final Set<Marker> markers = {};

    // 1. ユーザーの現在地のピン（青色に変えたいですが、まずは標準の赤で）
    // ※ myLocationEnabled: true にするので、ここでの追加は必須ではありませんが
    //   「中心」として意識するために追加してもOK。今回はシステム標準の青点を使うので省略します。

    // 2. お店のピンを全部追加
    for (var shop in widget.restaurants) {
      markers.add(
        Marker(
          markerId: MarkerId(shop.name), // IDはユニークなもの（名前やID）
          position: LatLng(shop.lat, shop.lng), // お店の場所
          infoWindow: InfoWindow(
            title: shop.name, // タップすると店名が出る
            snippet: shop.access, // サブタイトル
          ),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('周辺のcafe')),
      body: Column(
        children: [
          Expanded(
            flex: 1, // 画面の半分
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                // 最初は「自分の場所」を中心に表示
                target: LatLng(widget.userLat, widget.userLng),
                zoom: 14.0, // 少し広域に見えるように
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              myLocationEnabled: true, // 青い現在地マーク
              myLocationButtonEnabled: true, // 現在地に戻るボタン
              // ★ここがポイント：作ったピンをセットする
              markers: _createMarkers(),
            ),
          ),

          Expanded(
            flex: 1,
            child: widget.restaurants.isEmpty
                ? const Center(child: Text('近くにお店が見つかりませんでした'))
                : ListView.builder(
                    itemCount: widget.restaurants.length,
                    itemBuilder: (context, index) {
                      final shop = widget.restaurants[index];

                      double distanceInMeters = Geolocator.distanceBetween(
                        widget.userLat,
                        widget.userLng,
                        shop.lat, // お店の緯度
                        shop.lng, // お店の経度
                      );

                      // 表示用に整形（1km以上ならkm、未満ならm）
                      String distanceText = distanceInMeters >= 1000
                          ? "${(distanceInMeters / 1000).toStringAsFixed(1)}km"
                          : "${distanceInMeters.toInt()}m";

                      // 徒歩分数を計算（80m = 1分）
                      int walkingMinutes = (distanceInMeters / 80).ceil();

                      return Card(
                        // 少しデザインにこだわってCardを使う
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        color: AppColor.brand.primary,
                        child: ListTile(
                          leading: ClipRRect(
                            // 画像の角を丸くするとオシャレ
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              shop.photoImage, // サムネイル画像
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.restaurant,
                                    size: 40,
                                  ), // 画像エラー対策
                            ),
                          ),
                          title: Text(
                            shop.name, // 店舗名称
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shop.access, // アクセス
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.directions_walk,
                                    size: 16,
                                    color: Colors.pink[300],
                                  ),
                                  Text(
                                    " $distanceText (約$walkingMinutes分)",
                                    style: TextStyle(
                                      color: Colors.pink[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailPage(
                                  restaurant: shop,
                                  distanceText: distanceText,
                                  walkingMinutes: walkingMinutes,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
