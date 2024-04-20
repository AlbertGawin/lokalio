import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/create_notice/presentation/pages/create_notice_page.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';
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
          ..add(const GetAllNoticesEvent()),
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: NoticeListWidget(),
        ),
      ),
    );
  }
}
