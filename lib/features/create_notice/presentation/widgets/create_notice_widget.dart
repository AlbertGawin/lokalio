import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TitleInput(),
          const SizedBox(height: 8),
          _DescInput(),
        ],
      ),
    );
  }

  // void _validate(
  //   BuildContext context,
  //   GlobalKey<FormState> formKey,
  //   Map<String, dynamic> data,
  // ) {
  //   if (formKey.currentState != null && formKey.currentState!.validate()) {
  //     formKey.currentState!.save();
  //     final User? user = FirebaseAuth.instance.currentUser;

  //     if (user == null) {
  //       throw FirebaseAuthException(
  //         code: 'USER_NOT_LOGGED_IN',
  //         message: 'User is not logged in.',
  //       );
  //     }

  //     final NoticeDetails noticeDetails = NoticeDetails(
  //       id: '',
  //       userId: user.uid,
  //       title: data['title'],
  //       category: data['category'],
  //       moneyAmount: data['moneyAmount'],
  //       location: data['location'],
  //       description: data['description'],
  //       peopleAmount: data['peopleAmount'],
  //       imagesUrl: data['images'],
  //       createdAt: Timestamp.now().seconds.toString(),
  //     );

  //     context
  //         .read<CreateNoticeBloc>()
  //         .add(CreateNoticeDetailsEvent(noticeDetails: noticeDetails));
  //   }
  // }
}

class _TitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateNoticeCubit, CreateNoticeState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextFormField(
          key: const Key('createNotice_titleInput_textField'),
          onChanged: (title) =>
              context.read<CreateNoticeCubit>().titleChanged(title),
          decoration: InputDecoration(
            labelText: 'Tytuł',
            errorText:
                state.title.displayError != null ? 'invalid title' : null,
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
          onChanged: (description) =>
              context.read<CreateNoticeCubit>().descriptionChanged(description),
          decoration: InputDecoration(
            labelText: 'Opis',
            errorText: state.description.displayError != null
                ? 'invalid description'
                : null,
          ),
        );
      },
    );
  }
}
