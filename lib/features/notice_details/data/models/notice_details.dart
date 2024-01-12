import 'package:lokalio/features/notice_details/domain/entities/notice_details.dart';

class NoticeDetailsModel extends NoticeDetails {
  const NoticeDetailsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.userId,
  });

  factory NoticeDetailsModel.fromJson({required Map<String, dynamic> json}) {
    return NoticeDetailsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
    };
  }
}
