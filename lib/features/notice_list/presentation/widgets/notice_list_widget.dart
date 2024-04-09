import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lokalio/features/notice_list/notice_list.dart';

class NoticeListWidget extends StatelessWidget {
  const NoticeListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeListBloc, NoticeListState>(
      builder: (context, state) {
        switch (state.status) {
          case NoticeListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case NoticeListStatus.failure:
            return const Center(child: Text('Failed to fetch notices'));
          case NoticeListStatus.success:
            return MasonryGridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: state.notices.length,
              itemBuilder: (context, index) {
                return NoticeItemWidget(notice: state.notices[index]);
              },
            );
        }
      },
    );
  }
}
