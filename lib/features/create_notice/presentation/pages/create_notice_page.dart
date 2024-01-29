import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/create_notice_widget.dart';
import 'package:lokalio/injection_container.dart';

class CreateNoticePage extends StatelessWidget {
  const CreateNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dodaj ogłoszenie"),
        ),
        body: _buildBody(context),
      ),
    );
  }

  BlocProvider<CreateNoticeBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateNoticeBloc>(),
      child: BlocBuilder<CreateNoticeBloc, CreateNoticeState>(
        builder: (context, state) {
          if (state is CreateNoticeInitial || state is Loading) {
            return const CreateNoticeWidget();
          } else if (state is Done) {
            return const Center(child: Text('Done'));
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
