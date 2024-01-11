// ignore_for_file: constant_identifier_names

enum NoticeCategory {
  SIMPLE_JOB,
  HELP,
  MEETING,
}

extension NoticeCategoryExtension on NoticeCategory {
  String get name {
    switch (this) {
      case NoticeCategory.SIMPLE_JOB:
        return 'Simple Job';
      case NoticeCategory.HELP:
        return 'Help';
      case NoticeCategory.MEETING:
        return 'Meeting';
    }
  }

  String get description {
    switch (this) {
      case NoticeCategory.SIMPLE_JOB:
        return 'Simple Job Description';
      case NoticeCategory.HELP:
        return 'Help Description';
      case NoticeCategory.MEETING:
        return 'Meeting Description';
    }
  }

  String get icon {
    switch (this) {
      case NoticeCategory.SIMPLE_JOB:
        return 'assets/icons/simple_job.svg';
      case NoticeCategory.HELP:
        return 'assets/icons/help.svg';
      case NoticeCategory.MEETING:
        return 'assets/icons/meeting.svg';
    }
  }

  String get color {
    switch (this) {
      case NoticeCategory.SIMPLE_JOB:
        return '#FFC107';
      case NoticeCategory.HELP:
        return '#FF5722';
      case NoticeCategory.MEETING:
        return '#4CAF50';
    }
  }
}
