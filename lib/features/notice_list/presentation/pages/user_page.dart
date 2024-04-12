import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';
import 'package:lokalio/injection_container.dart';

class UserPage extends StatelessWidget {
  final String userId;

  const UserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: BlocProvider(
        create: (_) {
          final bloc = sl<NoticeListBloc>();

          bloc.add(ReadUserNoticesEvent(userId: userId));
          return bloc;
        },
        child: const NoticeListWidget(),
      ),
    );
  }
}
