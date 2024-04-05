import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

class NoticeDetailsModel extends NoticeDetails {
  const NoticeDetailsModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.moneyAmount,
    required super.location,
    required super.description,
    required super.peopleAmount,
    required super.imagesUrl,
    required super.createdAt,
  });

  factory NoticeDetailsModel.fromNoticeDetails(
      {required NoticeDetails noticeDetails}) {
    return NoticeDetailsModel(
      id: noticeDetails.id,
      userId: noticeDetails.userId,
      title: noticeDetails.title,
      category: noticeDetails.category,
      moneyAmount: noticeDetails.moneyAmount,
      location: noticeDetails.location,
      description: noticeDetails.description,
      peopleAmount: noticeDetails.peopleAmount,
      imagesUrl: noticeDetails.imagesUrl,
      createdAt: noticeDetails.createdAt,
    );
  }

  factory NoticeDetailsModel.fromJson({required Map<String, dynamic> json}) {
    return NoticeDetailsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      category: json['category'] as int,
      moneyAmount: json['moneyAmount'] as int,
      location: LatLng.fromJson(json['location']) as LatLng,
      description: json['description'] as String,
      peopleAmount: json['peopleAmount'] as int,
      imagesUrl: List<String>.from(json['imagesUrl']),
      createdAt: Timestamp.fromMillisecondsSinceEpoch(json['createdAt'] * 1000),
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
      'description': description,
      'peopleAmount': peopleAmount,
      'imagesUrl': imagesUrl,
      'createdAt': createdAt.seconds,
    };
  }

  Map<String, dynamic> toNoticeJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'moneyAmount': moneyAmount,
      'location': location.toJson(),
      'thumbnailUrl': imagesUrl.first,
    };
  }

  NoticeDetailsModel copyWith({
    String? id,
    String? userId,
    String? title,
    int? category,
    int? moneyAmount,
    LatLng? location,
    String? description,
    int? peopleAmount,
    List<String>? imagesUrl,
    Timestamp? createdAt,
  }) {
    return NoticeDetailsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      moneyAmount: moneyAmount ?? this.moneyAmount,
      location: location ?? this.location,
      description: description ?? this.description,
      peopleAmount: peopleAmount ?? this.peopleAmount,
      imagesUrl: imagesUrl ?? this.imagesUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
