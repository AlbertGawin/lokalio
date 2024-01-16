import 'package:flutter/material.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

class NoticeDetailsWidget extends StatelessWidget {
  final NoticeDetails noticeDetails;

  const NoticeDetailsWidget({
    super.key,
    required this.noticeDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(noticeDetails.title),
      ),
    );
  }
}
