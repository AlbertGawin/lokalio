part of 'notice_list_bloc.dart';

sealed class NoticeListEvent {
  const NoticeListEvent();
}

class GetAllNoticesEvent extends NoticeListEvent {
  const GetAllNoticesEvent();
}

final class GetUserNoticesEvent extends NoticeListEvent {
  final String userId;

  const GetUserNoticesEvent({required this.userId});
}
