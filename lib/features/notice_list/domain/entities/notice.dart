import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Notice extends Equatable {
  final String id;
  final String userId;
  final String title;
  final int category;
  final int moneyAmount;
  final LatLng location;
  final String thumbnailUrl;

  const Notice({
    required this.id,
    required this.userId,
    required this.title,
    required this.location,
    required this.category,
    required this.moneyAmount,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        category,
        moneyAmount,
        location,
        thumbnailUrl,
      ];
}
