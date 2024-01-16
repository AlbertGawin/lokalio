import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/create_notice_widget.dart';
import 'package:lokalio/injection_container.dart';

class CreateNoticePage extends StatelessWidget {
  const CreateNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _buildBody(context));
  }

  BlocProvider<CreateNoticeBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateNoticeBloc>(),
      child: BlocBuilder<CreateNoticeBloc, CreateNoticeState>(
        builder: (context, state) {
          if (state is CreateNoticeInitial) {
            return const Center(child: Text('CreateNoticePage'));
          } else if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Done) {
            return const CreateNoticeWidget();
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
