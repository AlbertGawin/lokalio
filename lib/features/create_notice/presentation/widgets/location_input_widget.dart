import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lokalio/core/util/api_keys.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/create_notice/presentation/pages/map_page.dart';

class LocationInputWidget extends StatefulWidget {
  const LocationInputWidget({
    super.key,
    required this.getLocation,
  });

  final void Function(LatLng location) getLocation;

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  LatLng? _pickedLocation;

  String gMapCircle({
    required var lat,
    required var lng,
    required var rad,
    int detail = 8,
  }) {
    String encSource = '';

    var r = 6371;

    lat = (lat * pi) / 180;
    lng = (lng * pi) / 180;
    var d = rad / r;

    for (var i = 0; i <= 360; i = i + detail) {
      var brng = i * pi / 180;

      var pLat = asin(sin(lat) * cos(d) + cos(lat) * sin(d) * cos(brng));
      var pLng = ((lng +
                  atan2(sin(brng) * sin(d) * cos(lat),
                      cos(d) - sin(lat) * sin(pLat))) *
              180) /
          pi;
      pLat = (pLat * 180) / pi;

      encSource += '|$pLat,$pLng';
    }

    return encSource;
  }

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    const mapW = 600;
    const mapH = 600;
    const zoom = 12;

    const circleRadius = 0.5;
    const circleRadiusThick = 12;
    final circFill = Theme.of(context)
        .colorScheme
        .primary
        .withOpacity(0.5)
        .value
        .toRadixString(16)
        .padLeft(6, '0');

    final circBorder = Theme.of(context)
        .colorScheme
        .primary
        .value
        .toRadixString(16)
        .padLeft(6, '0');

    var source = 'https://maps.googleapis.com/maps/api/staticmap?';
    source += 'zoom=$zoom&';
    source += 'size=${mapW}x$mapH&';
    source += 'maptype=roadmap&';
    source += 'language=pl&';
    source += 'markers=color:red|size:normal|$lat,$lng&';
    source += 'path=';
    source +=
        'color:0x${circBorder.substring(2)}${circBorder.substring(0, 2)}|';
    source +=
        'fillcolor:0x${circFill.substring(2)}${circFill.substring(0, 2)}|';
    source += 'weight:$circleRadiusThick';

    var encSource = gMapCircle(lat: lat, lng: lng, rad: circleRadius);
    source += '$encSource&';

    source += 'key=$googleAndroidGeoAPIKEY';

    return source;
  }

  void _selectOnMap() async {
    LatLng location = LatLng(
        _pickedLocation?.latitude ?? 52, _pickedLocation?.longitude ?? 19.1);
    await Navigator.of(context)
        .push(createRoute(
            MapPage(location: location, isSelected: _pickedLocation != null)))
        .then((position) {
      if (position != null) {
        setState(() {
          _pickedLocation = position;
        });
        widget.getLocation(_pickedLocation!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.add_location_alt_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 5),
          Text(
            'Wybierz lokalizację'.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );

    if (_pickedLocation != null) {
      content = Image.network(
        locationImage,
        fit: BoxFit.cover,
        height: 100,
        width: double.infinity,
      );
    }

    return InkWell(
      onTap: _selectOnMap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: content,
      ),
    );
  }
}
