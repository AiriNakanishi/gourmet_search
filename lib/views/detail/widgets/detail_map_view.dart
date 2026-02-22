import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gourmet_search/models/restaurant.dart';

class DetailMapView extends StatelessWidget {
  final Restaurant restaurant;

  const DetailMapView({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(restaurant.lat, restaurant.lng),
            zoom: 14.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId(restaurant.id),
              position: LatLng(restaurant.lat, restaurant.lng),
              infoWindow: InfoWindow(title: restaurant.name),
            ),
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
