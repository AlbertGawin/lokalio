import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/my_notices_widget.dart';
import 'package:lokalio/injection_container.dart';

class MyNoticesPage extends StatelessWidget {
  const MyNoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Moje ogłoszenia')),
        body: buildBody(context));
  }

  BlocProvider<NoticeListBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<NoticeListBloc>();
        bloc.add(const GetMyNoticesEvent());
        return bloc;
      },
      child: BlocBuilder<NoticeListBloc, NoticeListState>(
        builder: (context, state) {
          if (state is NoticeListInitial) {
            return const Center(child: Text('NoticeListInitial'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return MyNoticesWidget(noticeList: state.noticeList);
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
