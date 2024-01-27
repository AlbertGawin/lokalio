import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/domain/entities/notice.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/category_list_widget.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/search_bar_widget.dart';

class HomeWidget extends StatelessWidget {
  final List<Notice> noticeList;

  const HomeWidget({super.key, required this.noticeList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: RefreshIndicator(
        onRefresh: () {
          context.read<NoticeListBloc>().add(const GetAllNoticesEvent());
          return Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              const SearchBarWidget(),
              const SizedBox(height: 16),
              const CategoryListWidget(),
              const SizedBox(height: 16),
              NoticeListWidget(noticeList: noticeList),
            ],
          ),
        ),
      ),
    );
  }
}
