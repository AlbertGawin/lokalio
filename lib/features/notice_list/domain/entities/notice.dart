import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Notice extends Equatable {
  final String id;
  final String userId;
  final String title;
  final int category;
  final int amountInCash;
  final Position location;
  final DateTimeRange dateTimeRange;
  final String? thumbnailUrl;

  const Notice({
    required this.id,
    required this.userId,
    required this.title,
    required this.location,
    required this.category,
    required this.amountInCash,
    required this.dateTimeRange,
    this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        location,
        category,
        amountInCash,
        dateTimeRange,
        thumbnailUrl,
      ];
}
