import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/restaurant.dart';
import 'dart:convert';

class ApiClient {
  final Dio _dio = Dio();
  final String _apiKey = dotenv.get('HOTPEPPER_API_KEY');

  Future<List<Restaurant>> fetchRestaurants(
    double lat,
    double lng,
    int range, {
    int start = 1,
    String genre = '',
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'key': _apiKey,
        'lat': lat,
        'lng': lng,
        'range': range,
        'format': 'json',
        'count': 20,
        'start': start,
      };

      if (genre.isNotEmpty) {
        queryParams['genre'] = genre;
      }

      final response = await _dio.get(
        'https://webservice.recruit.co.jp/hotpepper/gourmet/v1/',
        queryParameters: queryParams,
      );

      final Map<String, dynamic> data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      final List shops = data['results']['shop'] ?? [];
      return shops.map((shop) => Restaurant.fromJson(shop)).toList();
    } catch (e) {
      throw Exception('データ取得に失敗: $e');
    }
  }
}
