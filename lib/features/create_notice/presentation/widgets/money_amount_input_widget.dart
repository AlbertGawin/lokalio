import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';

class MoneyAmountInput extends StatelessWidget {
  const MoneyAmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoticeCubit, CreateNoticeState>(
      buildWhen: (previous, current) =>
          previous.moneyAmount != current.moneyAmount,
      builder: (context, state) {
        return TextFormField(
          key: const Key('createNotice_moneyAmountInput_textField'),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (moneyAmount) =>
              context.read<CreateNoticeCubit>().moneyAmountChanged(moneyAmount),
          decoration: InputDecoration(
            labelText: 'Cena',
            errorText:
                state.moneyAmount.displayError != null ? 'Podaj kwotę' : null,
          ),
        );
      },
    );
  }
}
