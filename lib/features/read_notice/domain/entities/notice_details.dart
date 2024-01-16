import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeDetails extends Notice {
  final String description;
  final int amountInKind;
  final List<String>? imagesUrl;

  const NoticeDetails({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.amountInCash,
    required super.location,
    required super.dateTimeRange,
    required this.description,
    required this.amountInKind,
    this.imagesUrl,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        category,
        amountInCash,
        location,
        dateTimeRange,
        description,
        location,
        amountInKind,
        imagesUrl,
      ];
}
