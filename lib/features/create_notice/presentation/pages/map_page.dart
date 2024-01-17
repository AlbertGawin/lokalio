import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    this.location = const LatLng(52, 19.1),
    this.isSelecting = true,
  });

  final LatLng location;
  final bool isSelecting;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();

    _checkLocationPermission();
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    LocationData locationData;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      locationData = await location.getLocation();

      final lat = locationData.latitude;
      final lng = locationData.longitude;

      if (lat == null || lng == null) {
        return;
      }

      if (mounted) {
        setState(() {
          _pickedLocation = LatLng(lat, lng);
        });
      }
    } on TimeoutException {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Problem z pobraniem twojej lokalizacji.'),
          ),
        );
      }

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Wybierz lokalizację' : 'Your location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onLongPress: !widget.isSelecting
                      ? null
                      : (position) {
                          setState(() {
                            _pickedLocation = position;
                          });
                        },
                  circles: {
                    if (_pickedLocation != null)
                      Circle(
                        circleId: const CircleId('Okolica'),
                        center: _pickedLocation!,
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
                    target: _pickedLocation != null
                        ? _pickedLocation!
                        : LatLng(
                            widget.location.latitude,
                            widget.location.longitude,
                          ),
                    zoom: 5.8,
                  ),
                  markers: (_pickedLocation == null && widget.isSelecting)
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('m1'),
                            position: _pickedLocation ??
                                LatLng(
                                  widget.location.latitude,
                                  widget.location.longitude,
                                ),
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
                    onPressed: _pickedLocation == null
                        ? null
                        : () {
                            Navigator.of(context).pop(_pickedLocation);
                          },
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

  void _checkLocationPermission() async {
    await Permission.location.status.then((status) async {
      if (!status.isGranted) {
        try {
          // Request permission
          status = await Permission.location.request();
        } catch (e) {
          // Handle exception
          print('Permission request failed: $e');
        }
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location permission is denied'),
            ),
          );
        } else {
          _getCurrentLocation();
        }
      }
    });
  }
}
