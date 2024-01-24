import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';

class HomePageWidget extends StatelessWidget {
  final List<Notice> noticeList;

  const HomePageWidget({super.key, required this.noticeList});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        context.read<NoticeListBloc>().add(GetAllNoticesEvent());
        return Future.delayed(const Duration(seconds: 1));
      },
      child: NoticeListWidget(noticeList: noticeList),
    );
  }
}
