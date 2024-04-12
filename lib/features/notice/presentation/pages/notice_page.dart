import 'package:flutter/material.dart';
import 'package:lokalio/features/notice/presentation/widgets/notice_widget.dart';

class NoticePage extends StatelessWidget {
  final String noticeId;

  const NoticePage({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: NoticeWidget(noticeId: noticeId),
    );
  }
}
