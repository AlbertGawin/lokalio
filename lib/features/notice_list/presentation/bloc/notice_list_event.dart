part of 'notice_list_bloc.dart';

sealed class NoticeListEvent extends Equatable {
  const NoticeListEvent();

  @override
  List<Object> get props => [];
}

final class GetUserNoticesEvent extends NoticeListEvent {
  final String userId;

  const GetUserNoticesEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetAllNoticesEvent extends NoticeListEvent {}
