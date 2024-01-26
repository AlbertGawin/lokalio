import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/notice_list/presentation/widgets/user_widget.dart';
import 'package:lokalio/injection_container.dart';

class UserPage extends StatelessWidget {
  final String userId;

  const UserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: buildBody(context));
  }

  BlocProvider<NoticeListBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<NoticeListBloc>();
        bloc.add(GetUserNoticesEvent(userId: userId));
        return bloc;
      },
      child: BlocBuilder<NoticeListBloc, NoticeListState>(
        builder: (context, state) {
          if (state is NoticeListInitial) {
            return const Center(child: Text('NoticeListInitial'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return UserWidget(userId: userId, noticeList: state.noticeList);
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
