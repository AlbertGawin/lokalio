import 'package:flutter/material.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice/presentation/pages/notice_page.dart';
import 'package:transparent_image/transparent_image.dart';

class NoticeItemWidget extends StatelessWidget {
  final Notice notice;

  const NoticeItemWidget({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
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
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${notice.moneyAmount} ',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const TextSpan(
                            text: 'zł',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notice.title,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                highlightColor: Theme.of(context).primaryColor.withOpacity(0.2),
                onTap: () {
                  Navigator.of(context).push(createRoute(
                    NoticePage(noticeId: notice.id),
                  ));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
