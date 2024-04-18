import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';

class DescInput extends StatelessWidget {
  const DescInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoticeCubit, CreateNoticeState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return TextFormField(
          key: const Key('createNotice_descriptionInput_textField'),
          keyboardType: TextInputType.multiline,
          minLines: 3,
          maxLines: 3,
          onChanged: (description) =>
              context.read<CreateNoticeCubit>().descriptionChanged(description),
          decoration: InputDecoration(
            labelText: 'Opis',
            errorText:
                state.description.displayError != null ? 'Wpisz opis' : null,
          ),
        );
      },
    );
  }
}
