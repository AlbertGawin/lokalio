part of 'notice_bloc.dart';

sealed class NoticeEvent extends Equatable {
  const NoticeEvent();

  @override
  List<Object> get props => [];
}

final class GetNoticeDetailsEvent extends NoticeEvent {
  final String noticeId;

  const GetNoticeDetailsEvent({required this.noticeId});

  @override
  List<Object> get props => [noticeId];
}
