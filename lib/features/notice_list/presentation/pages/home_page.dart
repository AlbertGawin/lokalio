import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/create_notice/create_notice.dart';
import 'package:lokalio/features/notice_list/notice_list.dart';
import 'package:lokalio/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page page() => const MaterialPage(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(createRoute(const CreateNoticePage()));
        },
        child: const Icon(Icons.add),
      ),
      body: BlocProvider(
        create: (_) => NoticeListBloc(repository: sl<NoticeListRepository>())
          ..add(const ReadAllNoticesEvent()),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: NoticeListWidget(),
        ),
      ),
    );
  }
}
