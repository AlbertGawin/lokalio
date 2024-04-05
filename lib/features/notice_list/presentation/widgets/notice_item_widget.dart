import 'package:flutter/material.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/read_notice/presentation/pages/notice_page.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:transparent_image/transparent_image.dart';

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
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(0),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.memoryNetwork(
              image: notice.thumbnailUrl,
              placeholder: kTransparentImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${notice.moneyAmount} zł',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
