import 'package:flutter/material.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/user_details_widget.dart';

class UserWidget extends StatelessWidget {
  final String userId;
  final List<Notice> noticeList;

  const UserWidget({super.key, required this.noticeList, required this.userId});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        const SliverAppBar(backgroundColor: Colors.transparent, pinned: true),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              UserDetailsWidget(userId: userId),
              const SizedBox(height: 16),
              NoticeListWidget(noticeList: noticeList),
            ],
          ),
        ),
      ],
    );
  }
}
