import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeModel extends Notice {
  const NoticeModel({
    required super.id,
    required super.title,
    required super.userId,
  });

  factory NoticeModel.fromJson({required Map<String, dynamic> json}) {
    return NoticeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
    };
  }
}
