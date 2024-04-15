import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/create_notice/domain/entities/notice_category.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';
import 'package:lokalio/features/create_notice/presentation/pages/choose_category_page.dart';

class CreateNoticeWidget extends StatelessWidget {
  const CreateNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateNoticeCubit, CreateNoticeState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Create Notice Failure'),
              ),
            );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TitleInput(),
            const SizedBox(height: 8),
            _DescInput(),
            const SizedBox(height: 8),
            _CategoryInput(),
            const SizedBox(height: 8),
            _MoneyAmountInput(),
            const SizedBox(height: 8),
            _PeopleAmountInput(),
          ],
        ),
      ),
    );
  }
}

class _TitleInput extends StatelessWidget {
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

class _DescInput extends StatelessWidget {
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

class _CategoryInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoticeCubit, CreateNoticeState>(
      buildWhen: (previous, current) => previous.category != current.category,
      builder: (context, state) {
        final index = state.category.value;

        return FormField(
            key: const Key('createNotice_categoryInput_textField'),
            builder: (FormFieldState formState) {
              return InkWell(
                onTap: () async {
                  await Navigator.of(context)
                      .push(createRoute(const ChooseCategoryPage()))
                      .then((index) {
                    if (index != null) {
                      context
                          .read<CreateNoticeCubit>()
                          .categoryChanged(NoticeCategory.values[index].index);
                    }
                  });
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    color: NoticeCategory.values[index].color.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    NoticeCategory.values[index].name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}

class _MoneyAmountInput extends StatelessWidget {
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

class _PeopleAmountInput extends StatelessWidget {
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
