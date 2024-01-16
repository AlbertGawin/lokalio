import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeModel extends Notice {
  const NoticeModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.amountInCash,
    required super.location,
    required super.dateTimeRange,
    super.thumbnailUrl,
  });

  factory NoticeModel.fromJson({required Map<String, dynamic> json}) {
    return NoticeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      category: json['category'] as int,
      amountInCash: json['amountInCash'] as int,
      location: Position.fromMap(json['location'] as Map<String, dynamic>),
      dateTimeRange: DateTimeRange(
        start: DateTime.parse(json['dateTimeRange']['start'] as String),
        end: DateTime.parse(json['dateTimeRange']['end'] as String),
      ),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'amountInCash': amountInCash,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': location.timestamp.millisecondsSinceEpoch,
      },
      'dateTimeRange': {
        'start': dateTimeRange.start.toIso8601String(),
        'end': dateTimeRange.end.toIso8601String(),
      },
      'thumbnailUrl': thumbnailUrl ?? '',
    };
  }

  NoticeModel copyWith({
    String? id,
    String? userId,
    String? title,
    int? category,
    int? amountInCash,
    Position? location,
    DateTimeRange? dateTimeRange,
    String? thumbnailUrl,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      location: location ?? this.location,
      category: category ?? this.category,
      amountInCash: amountInCash ?? this.amountInCash,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
