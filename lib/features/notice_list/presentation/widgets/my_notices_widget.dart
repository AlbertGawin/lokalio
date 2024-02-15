import 'package:flutter/material.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';

class MyNoticesWidget extends StatelessWidget {
  final List<Notice> noticeList;

  const MyNoticesWidget({super.key, required this.noticeList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: NoticeListWidget(noticeList: noticeList),
    );
  }
}
