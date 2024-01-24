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

  String _lastWord() {
    String lastWord = 'OGŁOSZENIA';
    if (noticeList.length == 1) {
      lastWord = 'OGŁOSZENIE';
    } else if (noticeList.length > 4) {
      lastWord = 'OGŁOSZEŃ';
    }

    return lastWord;
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
                  onPressed: () {
                    context.read<NoticeListBloc>().add(GetAllNoticesEvent());
                  },
                  child: const Text('Refresh'),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${noticeList.length} ${_lastWord()}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                MasonryGridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: noticeList.length,
                  itemBuilder: (context, index) {
                    return NoticeItemWidget(notice: noticeList[index]);
                  },
                ),
              ],
            ),
          );
  }
}
