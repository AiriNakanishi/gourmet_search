import 'package:flutter/material.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_search/constants/app_data.dart';
import 'package:gourmet_search/repositories/api_client.dart';
import 'package:gourmet_search/views/detail/restaurant_detail_page.dart';
import 'package:gourmet_search/views/list/widgets/result_map_view.dart';
import 'package:gourmet_search/views/list/widgets/restaurant_list_item.dart';
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
    // 最初のデータセット
    _restaurantList = widget.restaurants;

    // スクロール監視
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiClient = ApiClient();
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
      debugPrint("追加読み込みエラー: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          '${AppData.getRangeText(widget.range)}圏内の${AppData.getGenreText(widget.genreCode)}',
        ),
        elevation: 1,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        shadowColor: AppColor.ui.gray,
      ),
      body: Column(
        children: [
          ResultMapView(
            userLat: widget.userLat,
            userLng: widget.userLng,
            markers: _createMarkers(),
            onMapCreated: (controller) => _mapController = controller,
          ),

          Expanded(
            flex: 1,
            child: widget.restaurants.isEmpty
                ? const Center(child: Text('お店が見つかりませんでした'))
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

                      String distanceText = distanceInMeters >= 1000
                          ? "${(distanceInMeters / 1000).toStringAsFixed(1)}km"
                          : "${distanceInMeters.toInt()}m";

                      int walkingMinutes = (distanceInMeters / 80).ceil();

                      return RestaurantListItem(
                        shop: _restaurantList[index],
                        userLat: widget.userLat,
                        userLng: widget.userLng,

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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
