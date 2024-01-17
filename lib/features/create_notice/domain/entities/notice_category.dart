import 'package:flutter/material.dart';

enum NoticeCategory {
  general,
  event,
  announcement,
  sale,
  job,
}

extension NoticeCategoryExtension on NoticeCategory {
  String get name {
    switch (this) {
      case NoticeCategory.general:
        return 'Ogłoszenie';
      case NoticeCategory.event:
        return 'Wydarzenie';
      case NoticeCategory.announcement:
        return 'Ogłoszenie';
      case NoticeCategory.sale:
        return 'Sprzedaż';
      case NoticeCategory.job:
        return 'Praca';
    }
  }

  IconData get icon {
    switch (this) {
      case NoticeCategory.general:
        return Icons.library_books_outlined;
      case NoticeCategory.event:
        return Icons.event_outlined;
      case NoticeCategory.announcement:
        return Icons.announcement_outlined;
      case NoticeCategory.sale:
        return Icons.shopping_bag_outlined;
      case NoticeCategory.job:
        return Icons.work_outline_outlined;
    }
  }

  Color get color {
    switch (this) {
      case NoticeCategory.general:
        return Colors.blue;
      case NoticeCategory.event:
        return Colors.green;
      case NoticeCategory.announcement:
        return Colors.red;
      case NoticeCategory.sale:
        return Colors.orange;
      case NoticeCategory.job:
        return Colors.purple;
    }
  }
}
