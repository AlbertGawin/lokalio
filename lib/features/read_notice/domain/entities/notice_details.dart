import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeDetails extends Notice {
  final String description;
  final int peopleAmount;
  final List<String>? imagesUrl;

  const NoticeDetails({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.cashAmount,
    required super.location,
    required super.dateTimeRange,
    required this.description,
    required this.peopleAmount,
    this.imagesUrl,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        category,
        cashAmount,
        location,
        dateTimeRange,
        description,
        location,
        peopleAmount,
        imagesUrl,
      ];
}
