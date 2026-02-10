import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  // Riverpodを使用するためにProviderScopeで包みます
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gourmet Search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), // お好みの緑色に
        useMaterial3: true,
      ),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _locationMessage = "ボタンを押して現在地を取得";

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
              child: const Text("現在地を取得"),
            ),
            Text("はろーわーるど"),
          ],
        ),
      ),
    );
  }
}
