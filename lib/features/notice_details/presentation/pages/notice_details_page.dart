import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/notice_details/presentation/bloc/notice_details_bloc.dart';
import 'package:lokalio/features/notice_details/presentation/widgets/notice_details_widget.dart';
import 'package:lokalio/injection_container.dart';

class NoticeDetailsPage extends StatelessWidget {
  final String noticeId;

  const NoticeDetailsPage({super.key, required this.noticeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  BlocProvider<NoticeDetailsBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<NoticeDetailsBloc>();

        bloc.add(GetNoticeDetailsEvent(noticeId: noticeId));

        return bloc;
      },
      child: BlocBuilder<NoticeDetailsBloc, NoticeDetailsState>(
        builder: (context, state) {
          if (state is NoticeDetailsInitial) {
            return const Center(child: Text('NoticeDetailsPage'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return NoticeDetailsWidget(noticeDetails: state.noticeDetails);
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
