import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokalio/features/create_notice/domain/entities/notice_category.dart';
import 'package:lokalio/features/create_notice/presentation/cubit/create_notice_cubit.dart';

class ChooseCategoryPage extends StatelessWidget {
  const ChooseCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateNoticeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wybierz kategorię'),
        ),
        body: SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: NoticeCategory.values.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Navigator.of(context)
                    .pop(NoticeCategory.values[index].index),
                child: Container(
                  width: double.infinity,
                  height: 80,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 4),
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
            },
          ),
        ),
      ),
    );
  }
}
