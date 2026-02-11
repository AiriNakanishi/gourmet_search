import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/restaurant.dart';

class ApiClient {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.get('HOTPEPPER_API_KEY');

  Future<List<Restaurant>> fetchRestaurants(
    double lat,
    double lng,
    int range,
  ) async {
    try {
      final response = await _dio.get(
        'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/',
        queryParameters: {
          'key': _apiKey,
          'lat': lat,
          'lng': lng,
          'range': range, // 1:300m, 2:500m...
          'format': 'json',
          'count': 20, // 最初の1ページ分 [cite: 25]
        },
      );

      final List shops = response.data['results']['shop'];
      return shops.map((shop) => Restaurant.fromJson(shop)).toList();
    } catch (e) {
      throw Exception('データの取得に失敗しました: $e');
    }
  }
}
