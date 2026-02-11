import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_search/repositories/api_client.dart';
import 'package:gourmet_search/views/list/restaurant_list_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _locationMessage = "ボタンを押して現在地を取得";
  Position? _currentPosition; //現在地を保有
  int selectedRange = 3; //検索半径の初期値

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

    setState(() {
      _currentPosition = position;
      _locationMessage = "緯度: ${position.latitude}\n経度: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("レストラン検索")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_locationMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("① 現在地を取得"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _currentPosition == null
                  ? null
                  : () async {
                      try {
                        // print("API Key: ${dotenv.env['HOTPEPPER_API_KEY']}");
                        final apiClient = ApiClient();
                        final results = await apiClient.fetchRestaurants(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                          selectedRange,
                        );

                        if (mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RestaurantListPage(restaurants: results),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('エラー: $e')));
                      }
                    },
              child: const Text("② 周辺のレストランを検索"),
            ),
            Text("はろーわーるど"),
          ],
        ),
      ),
    );
  }
}
