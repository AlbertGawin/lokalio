import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeDetails extends Notice {
  final String description;
  final int peopleAmount;
  final List<String> imagesUrl;
  final Timestamp createdAt;

  const NoticeDetails({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.moneyAmount,
    required super.location,
    required this.description,
    required this.peopleAmount,
    required this.imagesUrl,
    required this.createdAt,
  }) : super(thumbnailUrl: '');

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        category,
        moneyAmount,
        location,
        description,
        peopleAmount,
        imagesUrl,
        createdAt,
      ];
}
