import 'package:flutter/material.dart';
import 'package:lokalio/features/notice_details/domain/entities/notice_details.dart';

class NoticeDetailsWidget extends StatelessWidget {
  final NoticeDetails noticeDetails;

  const NoticeDetailsWidget({
    super.key,
    required this.noticeDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(noticeDetails.title),
    );
  }
}
