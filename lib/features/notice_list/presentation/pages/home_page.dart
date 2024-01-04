import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/notice_list_widget.dart';
import 'package:lokalio/injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  BlocProvider<NoticeListBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<NoticeListBloc>();

        bloc.add(GetAllNoticesEvent());

        return bloc;
      },
      child: BlocBuilder<NoticeListBloc, NoticeListState>(
        builder: (context, state) {
          if (state is NoticeListInitial) {
            return const Center(child: Text('NoticeInitial'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return NoticeListWidget(noticeList: state.noticeList);
          } else if (state is Error) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
