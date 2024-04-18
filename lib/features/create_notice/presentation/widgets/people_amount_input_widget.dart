import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';

class PeopleAmountInput extends StatelessWidget {
  const PeopleAmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoticeCubit, CreateNoticeState>(
      buildWhen: (previous, current) =>
          previous.peopleAmount != current.peopleAmount,
      builder: (context, state) {
        return TextFormField(
          key: const Key('createNotice_peopleAmountInput_textField'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (peopleAmount) => context
              .read<CreateNoticeCubit>()
              .peopleAmountChanged(peopleAmount),
          decoration: InputDecoration(
            labelText: 'Ilość ludzi',
            errorText: state.peopleAmount.displayError != null
                ? 'Podaj ilość ludzi'
                : null,
          ),
        );
      },
    );
  }
}
