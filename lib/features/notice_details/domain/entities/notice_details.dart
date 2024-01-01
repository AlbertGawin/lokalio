import 'package:lokalio/features/home/domain/entities/notice.dart';

class NoticeDetails extends Notice {
  final String description;

  const NoticeDetails({
    required super.id,
    required super.title,
    required this.description,
    required super.userId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
      ];
}
