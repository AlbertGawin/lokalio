import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/core/util/create_route.dart';
import 'package:lokalio/features/create_notice/domain/entities/notice_category.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';
import 'package:lokalio/features/create_notice/presentation/pages/choose_category_page.dart';

class CategoryInput extends StatelessWidget {
  const CategoryInput({super.key});

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
