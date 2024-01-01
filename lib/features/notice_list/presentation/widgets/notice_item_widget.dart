import 'package:flutter/material.dart';
import 'package:lokalio/features/notice_details/presentation/pages/notice_details_page.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';

class NoticeItemWidget extends StatelessWidget {
  final Notice notice;

  const NoticeItemWidget({
    super.key,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoticeDetailsPage(noticeId: notice.id),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                notice.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
