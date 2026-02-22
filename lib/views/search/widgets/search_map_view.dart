import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_search/constants/app_color.dart';

class SearchMapView extends StatelessWidget {
  final double lat;
  final double lng;
  final double radius;
  final Function(GoogleMapController) onMapCreated;

  const SearchMapView({
    super.key,
    required this.lat,
    required this.lng,
    required this.radius,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, lng),
            zoom: 14.0,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          circles: {
            Circle(
              circleId: const CircleId('search_range'),
              center: LatLng(lat, lng),
              radius: radius,
              // ignore: deprecated_member_use
              fillColor: Colors.pink.withOpacity(0.2),
              strokeColor: AppColor.ui.primary,
              strokeWidth: 2,
            ),
          },
        ),
      ),
    );
  }
}
