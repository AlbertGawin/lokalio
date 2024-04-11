import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/notice_list.dart';
import 'package:lokalio/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dom')),
      body: BlocProvider(
        create: (_) => NoticeListBloc(repository: sl<NoticeListRepository>())
          ..add(const GetAllNoticesEvent()),
        child: const NoticeListWidget(),
      ),
    );
  }
}
