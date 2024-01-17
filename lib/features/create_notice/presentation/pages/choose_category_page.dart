import 'package:flutter/material.dart';
import 'package:lokalio/features/create_notice/domain/entities/notice_category.dart';

class ChooseCategoryPage extends StatelessWidget {
  const ChooseCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz kategorię'),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: NoticeCategory.values.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.of(context).pop(
                NoticeCategory.values[index].index,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: NoticeCategory.values[index].color.withOpacity(0.25),
                ),
                height: 80,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: NoticeCategory.values[index].color,
                        ),
                        child: Icon(
                          NoticeCategory.values[index].icon,
                        ),
                      ),
                    ),
                    Text(
                      NoticeCategory.values[index].name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
