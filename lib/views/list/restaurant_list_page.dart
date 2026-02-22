import 'package:flutter/material.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_search/repositories/api_client.dart';
import 'package:gourmet_search/views/detail/restaurant_detail_page.dart';
import '../../models/restaurant.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantListPage extends StatefulWidget {
  final List<Restaurant> restaurants;
  final double userLat;
  final double userLng;
  final int range;
  final String genreCode;

  const RestaurantListPage({
    super.key,
    required this.restaurants,
    required this.userLat,
    required this.userLng,
    required this.range,
    this.genreCode = '',
  });

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  GoogleMapController? _mapController;
  List<Restaurant> _restaurantList = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 最初のデータをセット
    _restaurantList = widget.restaurants;

    // スクロール監視を開始
    _scrollController.addListener(() {
      // 「一番下」の少し手前まで来たら読み込み開始
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // メモリリーク防止
    super.dispose();
  }

  String _getRangeText(int range) {
    switch (range) {
      case 1:
        return "300m";
      case 2:
        return "500m";
      case 3:
        return "1km";
      case 4:
        return "2km";
      case 5:
        return "3km";
      default:
        return "1km";
    }
  }

  String _getGenreText(String genreCode) {
    switch (genreCode) {
      case 'G014':
        return 'カフェ・スイーツ';
      case 'G001':
        return '居酒屋';
      case 'G008':
        return '焼肉・ホルモン';
      case 'G013':
        return 'ラーメン';
      case 'G004':
        return '和食';
      case 'G006':
        return 'イタリアン・フレンチ';
      case 'G007':
        return '中華';
      case 'G005':
        return '洋食';
      case 'G017':
        return '韓国料理';
      case 'G016':
        return 'お好み焼き・もんじゃ';
      case 'G002':
        return 'ダイニングバー・バル';
      case 'G012':
        return 'バー・カクテル';
      case 'G009':
        return 'アジア・エスニック料理';
      case 'G003':
        return '創作料理';
      case 'G010':
        return '各国料理';
      case 'G011':
        return 'カラオケ・パーティ';
      case 'G015':
        return 'その他グルメ';
      default:
        return '飲食店';
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiClient = ApiClient();
      // 次の開始位置 = 今持っている数 + 1 (例: 10個持ってたら11番目から)
      int nextStart = _restaurantList.length + 1;

      // APIを叩く
      List<Restaurant> newRestaurants = await apiClient.fetchRestaurants(
        widget.userLat,
        widget.userLng,
        widget.range,
        start: nextStart,
        genre: widget.genreCode,
      );

      if (newRestaurants.isNotEmpty) {
        setState(() {
          // リストに追加する
          _restaurantList.addAll(newRestaurants);
        });
      }
    } catch (e) {
      // エラー処理（今回はコンソールに出すだけ）
      debugPrint("追加読み込みエラー: $e");
    } finally {
      setState(() {
        _isLoading = false; // 読み込み完了
      });
    }
  }

  // ピン（マーカー）のリストを作る関数
  Set<Marker> _createMarkers() {
    final Set<Marker> markers = {};
    for (var shop in _restaurantList) {
      markers.add(
        Marker(
          markerId: MarkerId(shop.id),
          position: LatLng(shop.lat, shop.lng),
          infoWindow: InfoWindow(title: shop.name, snippet: shop.access),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_getRangeText(widget.range)}圏内の${_getGenreText(widget.genreCode)}',
        ),
        elevation: 1,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColor.ui.gray,
      ),
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
                    target: LatLng(widget.userLat, widget.userLng),
                    zoom: 14.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  myLocationEnabled: true, // 青い現在地マーク
                  myLocationButtonEnabled: true, // 現在地に戻るボタン
                  markers: _createMarkers(),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: widget.restaurants.isEmpty
                ? const Center(child: Text('近くにお店が見つかりませんでした'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: _restaurantList.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _restaurantList.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final shop = _restaurantList[index];

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

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestaurantDetailPage(
                                  restaurant: shop,
                                  distanceText: distanceText,
                                  walkingMinutes: walkingMinutes,
                                  userLat: widget.userLat,
                                  userLng: widget.userLng,
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
