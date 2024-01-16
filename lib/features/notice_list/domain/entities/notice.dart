import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Notice extends Equatable {
  final String id;
  final String userId;
  final String title;
  final int category;
  final int amountInCash;
  final DateTimeRange dateRange;
  final String? thumbnailUrl;

  const Notice({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.amountInCash,
    required this.dateRange,
    this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        category,
        amountInCash,
        dateRange,
        thumbnailUrl,
      ];
}
