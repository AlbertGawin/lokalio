import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

class NoticeDetailsModel extends NoticeDetails {
  const NoticeDetailsModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.cashAmount,
    required super.location,
    required super.dateTimeRange,
    required super.description,
    required super.peopleAmount,
    super.imagesUrl,
  });

  Map<String, dynamic> toNoticeMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'cashAmount': cashAmount,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': location.timestamp.millisecondsSinceEpoch,
      },
      'dateTimeRange': {
        'start': dateTimeRange.start.toIso8601String(),
        'end': dateTimeRange.end.toIso8601String(),
      },
      'thumbnailUrl': imagesUrl?.first,
    };
  }

  factory NoticeDetailsModel.fromNoticeDetails({
    required NoticeDetails noticeDetails,
  }) {
    return NoticeDetailsModel(
      id: noticeDetails.id,
      userId: noticeDetails.userId,
      title: noticeDetails.title,
      category: noticeDetails.category,
      cashAmount: noticeDetails.cashAmount,
      location: noticeDetails.location,
      dateTimeRange: noticeDetails.dateTimeRange,
      description: noticeDetails.description,
      peopleAmount: noticeDetails.peopleAmount,
      imagesUrl: noticeDetails.imagesUrl,
    );
  }

  factory NoticeDetailsModel.fromJson({required Map<String, dynamic> json}) {
    return NoticeDetailsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      category: json['category'] as int,
      cashAmount: json['cashAmount'] as int,
      location: Position.fromMap(json['location'] as Map<String, dynamic>),
      dateTimeRange: DateTimeRange(
        start: DateTime.parse(json['dateTimeRange']['start'] as String),
        end: DateTime.parse(json['dateTimeRange']['end'] as String),
      ),
      description: json['description'] as String,
      peopleAmount: json['peopleAmount'] as int,
      imagesUrl:
          json['imagesUrl'] != null ? List<String>.from(json['imagesUrl']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'cashAmount': cashAmount,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': location.timestamp.millisecondsSinceEpoch,
      },
      'dateTimeRange': {
        'start': dateTimeRange.start.toIso8601String(),
        'end': dateTimeRange.end.toIso8601String(),
      },
      'description': description,
      'peopleAmount': peopleAmount,
      'imagesUrl': imagesUrl,
    };
  }

  NoticeDetailsModel copyWith({
    String? id,
    String? userId,
    String? title,
    int? category,
    int? cashAmount,
    Position? location,
    DateTimeRange? dateTimeRange,
    String? description,
    int? peopleAmount,
    List<String>? imagesUrl,
  }) {
    return NoticeDetailsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      cashAmount: cashAmount ?? this.cashAmount,
      location: location ?? this.location,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      description: description ?? this.description,
      peopleAmount: peopleAmount ?? this.peopleAmount,
      imagesUrl: imagesUrl ?? this.imagesUrl,
    );
  }
}
