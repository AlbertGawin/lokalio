import 'package:flutter/material.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

class NoticeWidget extends StatelessWidget {
  final NoticeDetails noticeDetails;

  const NoticeWidget({super.key, required this.noticeDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(noticeDetails.id),
        Text(noticeDetails.userId),
        Text(noticeDetails.title),
        Text(noticeDetails.category.toString()),
        Text(noticeDetails.amountInCash.toString()),
        Text(noticeDetails.location.longitude.toString()),
        Text(noticeDetails.location.latitude.toString()),
        Text(noticeDetails.dateTimeRange.toString()),
        Text(noticeDetails.description),
        Text(noticeDetails.amountInKind.toString()),
        Text(noticeDetails.imagesUrl.toString()),
      ],
    );
  }
}
