import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  final LatLng location;
  final bool isSelected;

  const MapPage({
    super.key,
    required this.location,
    required this.isSelected,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late LatLng _pickedLocation;
  late bool _isSelected;

  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();

    _pickedLocation = widget.location;
    _isSelected = widget.isSelected;
    _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelected ? 'Twoja lokalizacja' : 'Wybierz lokalizację'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _controller = controller;
                  },
                  onLongPress: (location) async {
                    setState(() {
                      _isSelected = true;
                      _pickedLocation = location;
                    });

                    if (_controller == null) {
                      return;
                    }

                    double currentZoom = await _controller!.getZoomLevel();
                    _controller!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: location,
                          zoom: 12 > currentZoom ? 12 : currentZoom,
                        ),
                      ),
                    );
                  },
                  circles: {
                    if (_isSelected)
                      Circle(
                        circleId: const CircleId('Okolica'),
                        center: _pickedLocation,
                        radius: 500,
                        strokeWidth: 2,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        strokeColor: Theme.of(context).colorScheme.primary,
                      ),
                  },
                  zoomControlsEnabled: true,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _pickedLocation,
                    zoom: _isSelected ? 12 : 6,
                  ),
                  markers: (!_isSelected)
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('m1'),
                            position: _pickedLocation,
                          ),
                        },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Wpisz lokalizację powyżej lub przytrzymaj palcem wybrane miejsce na mapie.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSelected
                        ? () {
                            Navigator.of(context).pop(_pickedLocation);
                          }
                        : null,
                    child: const Text('Wybierz'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      return;
    }

    if (status.isDenied) {
      await Permission.location.request();
    }
  }
}
