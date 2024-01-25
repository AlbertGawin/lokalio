import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/read_notice/presentation/bloc/read_notice_bloc.dart';
import 'package:lokalio/features/read_notice/presentation/widgets/notice_widget.dart';
import 'package:lokalio/injection_container.dart';

class NoticePage extends StatelessWidget {
  final String noticeId;

  const NoticePage({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: _buildBody(context),
    );
  }

  BlocProvider<ReadNoticeBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<ReadNoticeBloc>();

        bloc.add(ReadNoticeDetailsEvent(noticeId: noticeId));

        return bloc;
      },
      child: BlocBuilder<ReadNoticeBloc, ReadNoticeState>(
        builder: (context, state) {
          if (state is ReadNoticeInitial) {
            return const Center(child: Text('NoticePage'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return NoticeWidget(noticeDetails: state.noticeDetails);
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
