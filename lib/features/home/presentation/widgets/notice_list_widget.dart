import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lokalio/features/home/domain/entities/notice.dart';
import 'package:lokalio/features/home/presentation/widgets/notice_item_widget.dart';

class NoticeListWidget extends StatelessWidget {
  final List<Notice> noticeList;

  const NoticeListWidget({
    super.key,
    required this.noticeList,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      itemCount: noticeList.length,
      itemBuilder: (context, index) {
        return NoticeItemWidget(
          notice: noticeList[index],
        );
      },
    );
  }
}
