import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/create_notice_failure_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/create_notice_loading_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/create_notice_success_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/create_notice_widget.dart';
import 'package:lokalio/injection_container.dart';

class CreateNoticePage extends StatelessWidget {
  const CreateNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CreateNoticeBloc(repository: sl<CreateNoticeRepository>()),
        ),
        BlocProvider(create: (_) => CreateNoticeCubit()),
      ],
      child: BlocBuilder<CreateNoticeBloc, CreateNoticeState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              appBar: _buildAppBar(state),
              body: _buildBodyBasedOnStatus(context, state),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(CreateNoticeState state) {
    if (state.status == FormzSubmissionStatus.inProgress ||
        state.status == FormzSubmissionStatus.success) {
      return null;
    }

    return AppBar(
      title: const Text("Dodaj ogłoszenie"),
      elevation: 1.0,
      shadowColor: Colors.grey.shade100,
    );
  }

  Widget _buildBodyBasedOnStatus(
    BuildContext context,
    CreateNoticeState state,
  ) {
    switch (state.status) {
      case FormzSubmissionStatus.inProgress:
        return const CreateNoticeLoadingWidget();
      case FormzSubmissionStatus.success:
        return const CreateNoticeSuccessWidget();
      case FormzSubmissionStatus.failure:
        return const CreateNoticeFailureWidget();
      default:
        return const CreateNoticeWidget();
    }
  }
}
