import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/category_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/desc_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/images_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/money_amount_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/people_amount_input_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/submit_button_widget.dart';
import 'package:lokalio/features/create_notice/presentation/widgets/title_input_widget.dart';

class CreateNoticeWidget extends StatelessWidget {
  const CreateNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateNoticeCubit, CreateNoticeState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImagesInput(),
            SizedBox(height: 8),
            TitleInput(),
            SizedBox(height: 8),
            DescInput(),
            SizedBox(height: 8),
            CategoryInput(),
            SizedBox(height: 8),
            MoneyAmountInput(),
            SizedBox(height: 8),
            PeopleAmountInput(),
            SizedBox(height: 8),
            SubmitButtonWidget(),
          ],
        ),
      ),
    );
  }
}
