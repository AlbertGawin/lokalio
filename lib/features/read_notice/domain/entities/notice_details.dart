import 'package:lokalio/features/read_notice/domain/entities/notice.dart';

class NoticeDetails extends Notice {
  final String description;
  final String location;
  final int amountInKind;
  final List<String>? imagesUrl;

  const NoticeDetails({
    required super.id,
    required super.userId,
    required super.title,
    required super.category,
    required super.amountInCash,
    required super.dateRange,
    required this.description,
    required this.location,
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
        dateRange,
        description,
        location,
        amountInKind,
        imagesUrl,
      ];
}
