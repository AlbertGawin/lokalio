import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoticeCubit, CreateNoticeState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextFormField(
          key: const Key('createNotice_titleInput_textField'),
          keyboardType: TextInputType.text,
          inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
          onChanged: (title) =>
              context.read<CreateNoticeCubit>().titleChanged(title),
          decoration: InputDecoration(
            labelText: 'Tytuł',
            errorText: state.title.displayError != null ? 'Wpisz tytuł' : null,
          ),
        );
      },
    );
  }
}
