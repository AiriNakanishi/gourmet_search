import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gourmet_search/constants/app_color.dart';
import 'package:gourmet_search/constants/app_data.dart';
import 'package:gourmet_search/views/search/widgets/genre_selector.dart';
import 'package:gourmet_search/views/search/widgets/search_buttom.dart';
import 'package:gourmet_search/views/search/widgets/search_map_view.dart';
import 'package:gourmet_search/views/search/widgets/range_indicator.dart';
import '../../models/restaurant.dart';
import '../../repositories/api_client.dart';
import '../list/restaurant_list_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  int _selectedRange = 3;
  bool _isLoading = false;

  String _selectedGenre = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getCurrentLocation();

    FlutterNativeSplash.remove();
  }

  // 現在地を取得
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

  // 検索ボタンの処理
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
        genre: _selectedGenre,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantListPage(
            restaurants: results,
            userLat: _currentPosition!.latitude,
            userLng: _currentPosition!.longitude,
            range: _selectedRange,
            genreCode: _selectedGenre,
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
      appBar: _buildAppBar(),
      body: _currentPosition == null
          ? _buildLoadingView()
          : Column(
              children: [
                GenreSelector(
                  selectedGenre: _selectedGenre,
                  onGenreChanged: (code) {
                    setState(() {
                      _selectedGenre = code;
                    });
                  },
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SearchMapView(
                        lat: _currentPosition!.latitude,
                        lng: _currentPosition!.longitude,
                        radius: AppData.getRangeInMeters(_selectedRange),
                        onMapCreated: (controller) =>
                            _mapController = controller,
                      ),
                      RangeIndicator(
                        selectedRange: _selectedRange,
                        rangeText: AppData.getRangeText(_selectedRange),
                        onRangeChanged: (value) {
                          setState(() {
                            _selectedRange = value;
                          });
                        },
                      ),
                      SearchButton(
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _searchRestaurants,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('現在地から探す'),
      elevation: 1,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColor.ui.gray,
    );
  }

  Widget _buildLoadingView() {
    return Center(child: CircularProgressIndicator(color: AppColor.ui.primary));
  }
}
