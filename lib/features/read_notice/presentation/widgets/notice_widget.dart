import 'package:flutter/material.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';

class NoticeWidget extends StatelessWidget {
  final NoticeDetails noticeDetails;

  const NoticeWidget({super.key, required this.noticeDetails});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('NoticeWidget'));
  }
}
