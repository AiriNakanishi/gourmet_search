import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_search/repositories/api_client.dart';
import 'package:gourmet_search/views/list/restaurant_list_page.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _locationMessage = "ボタンを押して現在地を取得";
  Position? _currentPosition; //現在地を保有
  int selectedRange = 3; //検索半径の初期値
  GoogleMapController? _mapController;

  final List<Map<String, dynamic>> _rangeOptions = [
    {'label': '300m', 'value': 1},
    {'label': '500m', 'value': 2},
    {'label': '1000m', 'value': 3},
    {'label': '2000m', 'value': 4},
    {'label': '3000m', 'value': 5},
  ];

  // 位置情報を取得する関数
  Future<void> _getCurrentLocation() async {
    // 位置情報サービスが有効か確認
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _locationMessage = "位置情報サービスが無効です");
      return;
    }

    // 権限の確認
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _locationMessage = "位置情報の権限が拒否されました");
        return;
      }
    }

    // 現在地の取得
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (_mapController != null && _currentPosition != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        ),
      );
    }

    setState(() {
      _currentPosition = position;
      _locationMessage = "緯度: ${position.latitude}\n経度: ${position.longitude}";
    });
  }

  @override
  void initState() {
    super.initState();
    // 画面が開いたらすぐに現在地を取得し始める
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("cafe検索")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: _currentPosition == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.brand.secondary,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          // 初期位置を現在地に設定
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            ),
                            zoom: 15.0,
                          ),
                          myLocationEnabled: true, // 青い現在地マーク
                          myLocationButtonEnabled: true, // 現在地に戻る
                        ),
                      ),
                    ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(_locationMessage, textAlign: TextAlign.center),
                    const SizedBox(height: 20),

                    Text(
                      "検索半径を選択",
                      style: TextStyle(
                        color: AppColor.text.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColor.brand.secondary),
                      ),
                      child: DropdownButton<int>(
                        value: selectedRange, // 以前定義した変数
                        underline: const SizedBox(), // 下線を消すとおしゃれ
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: AppColor.brand.secondary,
                        ),
                        items: _rangeOptions.map((option) {
                          return DropdownMenuItem<int>(
                            value: option['value'],
                            child: Text(option['label']),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedRange = newValue;
                            });
                          }
                        },
                      ),
                    ),

                    ElevatedButton(
                      onPressed: _currentPosition == null
                          ? null
                          : () async {
                              try {
                                // print("API Key: ${dotenv.env['HOTPEPPER_API_KEY']}");
                                final apiClient = ApiClient();
                                final results = await apiClient
                                    .fetchRestaurants(
                                      _currentPosition!.latitude,
                                      _currentPosition!.longitude,
                                      selectedRange,
                                    );

                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RestaurantListPage(
                                        restaurants: results,
                                        userLat: _currentPosition!
                                            .latitude, // 自分の緯度を渡す
                                        userLng: _currentPosition!
                                            .longitude, // 自分の経度を渡す
                                        range: selectedRange,
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('エラー: $e')),
                                );
                              }
                            },
                      child: const Text("② 周辺のレストランを検索"),
                    ),
                    Text("はろーわーるど"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
