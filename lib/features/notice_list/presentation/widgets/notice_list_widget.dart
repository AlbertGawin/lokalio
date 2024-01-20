import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_item_widget.dart';

class NoticeListWidget extends StatelessWidget {
  final List<Notice> noticeList;

  const NoticeListWidget({
    super.key,
    required this.noticeList,
  });

  Future<void> _refresh(BuildContext context) async {
    context.read<NoticeListBloc>().add(GetAllNoticesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return noticeList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No notices found'),
                ElevatedButton(
                  onPressed: () => _refresh(context),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: MasonryGridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              itemCount: noticeList.length,
              itemBuilder: (context, index) {
                return NoticeItemWidget(notice: noticeList[index]);
              },
            ),
          );
  }
}
