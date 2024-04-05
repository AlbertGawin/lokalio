import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeModel extends Notice {
  const NoticeModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.moneyAmount,
    required super.location,
    required super.thumbnailUrl,
  });

  factory NoticeModel.fromJson({required Map<String, dynamic> json}) {
    return NoticeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      category: json['category'] as int,
      moneyAmount: json['moneyAmount'] as int,
      location: LatLng.fromJson(json['location']) as LatLng,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'moneyAmount': moneyAmount,
      'location': location.toJson(),
      'thumbnailUrl': thumbnailUrl,
    };
  }

  NoticeModel copyWith({
    String? id,
    String? userId,
    String? title,
    int? category,
    int? moneyAmount,
    LatLng? location,
    String? thumbnailUrl,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      moneyAmount: moneyAmount ?? this.moneyAmount,
      location: location ?? this.location,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
