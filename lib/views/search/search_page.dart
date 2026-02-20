import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_search/constants/app_color.dart'; // 色の設定があれば
import '../../models/restaurant.dart';
import '../../repositories/api_client.dart';
import '../list/restaurant_list_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  int _selectedRange = 3; // 初期値は 3 (1000m)
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // 現在地を取得する関数
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  // APIのrange値(1~5)から実際の距離(メートル)を返す関数
  double _getRangeInMeters(int range) {
    switch (range) {
      case 1:
        return 300;
      case 2:
        return 500;
      case 3:
        return 1000;
      case 4:
        return 2000;
      case 5:
        return 3000;
      default:
        return 1000;
    }
  }

  // APIのrange値(1~5)から画面に表示するテキストを返す関数
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

  // 検索ボタンを押したときの処理
  Future<void> _searchRestaurants() async {
    if (_currentPosition == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final apiClient = ApiClient();
      List<Restaurant> results = await apiClient.fetchRestaurants(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _selectedRange,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantListPage(
            restaurants: results,
            userLat: _currentPosition!.latitude,
            userLng: _currentPosition!.longitude,
            range: _selectedRange, // APIキーやページングのために渡す
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('現在地から探す')),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator(color: AppColor.ui.primary))
          : Stack(
              // ★ ここがポイント！地図の上にUIを重ねます
              children: [
                // 1. 一番下：角丸の地図と検索範囲の円
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: GoogleMap(
                      onMapCreated: (controller) => _mapController = controller,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        zoom: 14.0,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      // ★ ここで円を描画！
                      circles: {
                        Circle(
                          circleId: const CircleId('search_range'),
                          center: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          radius: _getRangeInMeters(
                            _selectedRange,
                          ), // スライダーの値に連動
                          fillColor: Colors.pink.withOpacity(0.2), // 半透明のピンク
                          strokeColor: AppColor.ui.primary,
                          strokeWidth: 2,
                        ),
                      },
                    ),
                  ),
                ),

                // 2. 右側に重ねる：縦型の距離調整スライダー
                Positioned(
                  right: 24,
                  top: 100, // 上からの位置
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9), // 少し透ける白背景
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getRangeText(_selectedRange),
                          style: TextStyle(
                            color: AppColor.text.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // ★ RotatedBoxでスライダーを縦にする！
                        RotatedBox(
                          quarterTurns: 3, // 270度回転 (下から上へ)
                          child: Slider(
                            value: _selectedRange.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4, // 1~5の5段階(間は4つ)
                            activeColor: AppColor.ui.primary,
                            inactiveColor: Colors.pink[100],
                            onChanged: (value) {
                              setState(() {
                                _selectedRange = value
                                    .toInt(); // スライダーを動かすと円が即座に変わる
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. 一番下に重ねる：検索ボタン
                Positioned(
                  bottom: 40,
                  left: 40,
                  right: 40,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _searchRestaurants,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.ui.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'この範囲でカフェを探す',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}
