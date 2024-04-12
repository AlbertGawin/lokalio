part of 'notice_list_bloc.dart';

sealed class NoticeListEvent {
  const NoticeListEvent();
}

class ReadAllNoticesEvent extends NoticeListEvent {
  const ReadAllNoticesEvent();
}

final class ReadUserNoticesEvent extends NoticeListEvent {
  final String userId;

  const ReadUserNoticesEvent({required this.userId});
}
