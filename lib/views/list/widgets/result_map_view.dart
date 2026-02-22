import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResultMapView extends StatelessWidget {
  final double userLat;
  final double userLng;
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const ResultMapView({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.markers,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(userLat, userLng),
              zoom: 14.0,
            ),
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markers,
          ),
        ),
      ),
    );
  }
}
