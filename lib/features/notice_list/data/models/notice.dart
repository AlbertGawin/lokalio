import 'package:flutter/material.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeModel extends Notice {
  const NoticeModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.amountInCash,
    required super.dateRange,
    super.thumbnailUrl,
  });

  factory NoticeModel.fromJson({required Map<String, dynamic> json}) {
    return NoticeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      category: json['category'] as int,
      amountInCash: json['amountInCash'] as int,
      dateRange: DateTimeRange(
        start: DateTime.parse(json['dateRange']['start'] as String),
        end: DateTime.parse(json['dateRange']['end'] as String),
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
      'dateRange': {
        'start': dateRange.start.toIso8601String(),
        'end': dateRange.end.toIso8601String(),
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
    DateTimeRange? dateRange,
    String? thumbnailUrl,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      amountInCash: amountInCash ?? this.amountInCash,
      dateRange: dateRange ?? this.dateRange,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
