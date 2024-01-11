import 'package:flutter/material.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';

class NoticeDetailsModel extends NoticeDetails {
  const NoticeDetailsModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.amountInCash,
    required super.dateRange,
    required super.description,
    required super.location,
    required super.amountInKind,
    super.imagesUrl,
  });

  factory NoticeDetailsModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return NoticeDetailsModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      category: json['category'],
      amountInCash: json['amountInCash'],
      dateRange: DateTimeRange(
        start: DateTime.parse(json['dateRange']['start']),
        end: DateTime.parse(json['dateRange']['end']),
      ),
      description: json['description'],
      location: json['location'],
      amountInKind: json['amountInKind'],
      imagesUrl: json['imagesUrl'] != null
          ? List<String>.from(json['imagesUrl'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'amountInCash': amountInCash,
      'dateRange': {
        'start': dateRange.start.toIso8601String(),
        'end': dateRange.end.toIso8601String(),
      },
      'description': description,
      'location': location,
      'amountInKind': amountInKind,
      'imagesUrl': imagesUrl,
    };
  }

  NoticeDetailsModel copyWith({
    String? id,
    String? userId,
    String? title,
    int? category,
    int? amountInCash,
    DateTimeRange? dateRange,
    String? description,
    String? location,
    int? amountInKind,
    List<String>? imagesUrl,
  }) {
    return NoticeDetailsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      amountInCash: amountInCash ?? this.amountInCash,
      dateRange: dateRange ?? this.dateRange,
      description: description ?? this.description,
      location: location ?? this.location,
      amountInKind: amountInKind ?? this.amountInKind,
      imagesUrl: imagesUrl ?? this.imagesUrl,
    );
  }
}
