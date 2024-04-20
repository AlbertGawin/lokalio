import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoticeCubit, CreateNoticeState>(
      buildWhen: (previous, current) => previous.isValid != current.isValid,
      builder: (context, state) {
        return FilledButton(
          onPressed: state.isValid ? _onPressed(context) : null,
          child: const Text("Wystaw ogłoszenie"),
        );
      },
    );
  }

  VoidCallback? _onPressed(BuildContext context) {
    return () {
      context.read<CreateNoticeBloc>().add(CreateNoticeDetailsEvent(
          noticeDetails:
              context.read<CreateNoticeCubit>().state.noticeDetails));
    };
  }
}
