import 'package:flutter/material.dart';
import 'package:gourmet_search/views/detail/restaurant_detail_page.dart';
import '../../models/restaurant.dart';

class RestaurantListPage extends StatelessWidget {
  final List<Restaurant> restaurants;

  const RestaurantListPage({super.key, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('周辺のcafe')),
      body: restaurants.isEmpty
          ? const Center(child: Text('近くにお店が見つかりませんでした'))
          : ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final shop = restaurants[index];
                return Card(
                  // 少しデザインにこだわってCardを使う
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
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
                            const Icon(Icons.restaurant, size: 40), // 画像エラー対策
                      ),
                    ),
                    title: Text(
                      shop.name, // 店舗名称
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      shop.access, // アクセス
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RestaurantDetailPage(restaurant: shop),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
