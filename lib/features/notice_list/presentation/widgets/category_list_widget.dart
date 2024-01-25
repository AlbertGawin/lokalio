import 'package:flutter/material.dart';
import 'package:lokalio/features/create_notice/domain/entities/notice_category.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: NoticeCategory.values.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: NoticeCategory.values[index].color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  NoticeCategory.values[index].icon,
                  color: NoticeCategory.values[index].color,
                  size: 32,
                ),
                const SizedBox(height: 4),
                Text(
                  NoticeCategory.values[index].name,
                  style: TextStyle(
                    color: NoticeCategory.values[index].color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
