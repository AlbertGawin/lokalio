import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lokalio/core/util/messages.dart';
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
  Position? _pickedLocation;
  late LatLng _pickedLatLng;
  late bool _isSelected;

  @override
  void initState() {
    super.initState();

    _pickedLatLng = widget.location;
    _isSelected = widget.isSelected;
    _checkLocationPermission();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      if (!_isSelected) {
        await location.getLocation().then((locationData) {
          final lat = locationData.latitude;
          final lng = locationData.longitude;

          if (lat == null || lng == null) {
            return;
          }

          if (mounted) {
            setState(() {
              _pickedLatLng = LatLng(lat, lng);
            });
          }
        });
      }
    } on TimeoutException {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text(locationErrorMessage)),
        );
    }
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
                  onLongPress: (position) {
                    setState(() {
                      _isSelected = true;
                      _pickedLatLng = position;
                    });
                  },
                  circles: {
                    if (_isSelected)
                      Circle(
                        circleId: const CircleId('Okolica'),
                        center: _pickedLatLng,
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
                    target: _pickedLatLng,
                    zoom: _isSelected ? 12 : 6,
                  ),
                  markers: (!_isSelected)
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('m1'),
                            position: _pickedLatLng,
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
                            _pickedLocation = Position.fromMap({
                              'latitude': _pickedLatLng.latitude,
                              'longitude': _pickedLatLng.longitude,
                              'timestamp':
                                  DateTime.now().millisecondsSinceEpoch,
                            });
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
      _getCurrentLocation();
      return;
    }

    if (status.isDenied) {
      await Permission.location.request();
    }
  }
}
