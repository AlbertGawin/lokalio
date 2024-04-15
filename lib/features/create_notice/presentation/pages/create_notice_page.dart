import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';
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
          elevation: 1.0,
          shadowColor: Colors.grey.shade100,
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  CreateNoticeBloc(repository: sl<CreateNoticeRepository>()),
            ),
            BlocProvider(create: (context) => CreateNoticeCubit()),
          ],
          child: BlocBuilder<CreateNoticeBloc, CreateNoticeState>(
            builder: (context, state) {
              if (state.status.isInProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const CreateNoticeWidget();
              }
            },
          ),
        ),
      ),
    );
  }
}
