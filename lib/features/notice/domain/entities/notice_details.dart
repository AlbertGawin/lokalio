import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeDetails extends Notice {
  final String description;
  final int peopleAmount;
  final List<String> imagesUrl;
  final String createdAt;

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

  static const empty = NoticeDetails(
    id: '',
    userId: '',
    title: '',
    category: -1,
    moneyAmount: -1,
    location: LatLng(0.0, 0.0),
    description: '',
    peopleAmount: 0,
    imagesUrl: [],
    createdAt: '',
  );

  bool get isEmpty => this == NoticeDetails.empty;

  bool get isNotEmpty => this != NoticeDetails.empty;

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
