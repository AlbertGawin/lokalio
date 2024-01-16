import 'package:flutter/material.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/read_notice/presentation/pages/notice_page.dart';
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
        Navigator.of(context).push(
          createRoute(NoticePage(noticeId: notice.id)),
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
