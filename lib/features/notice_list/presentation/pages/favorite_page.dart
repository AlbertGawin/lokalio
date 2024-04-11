import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/notice_list.dart';
import 'package:lokalio/injection_container.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ulubione')),
      body: BlocProvider(
        create: (_) {
          final bloc = sl<NoticeListBloc>();

          bloc.add(const GetAllNoticesEvent());
          return bloc;
        },
        child: const NoticeListWidget(),
      ),
    );
  }
}
