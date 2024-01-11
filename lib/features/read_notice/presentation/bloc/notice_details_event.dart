part of 'notice_details_bloc.dart';

sealed class NoticeDetailsEvent extends Equatable {
  const NoticeDetailsEvent();

  @override
  List<Object> get props => [];
}

final class GetNoticeDetailsEvent extends NoticeDetailsEvent {
  final String noticeId;

  const GetNoticeDetailsEvent({required this.noticeId});

  @override
  List<Object> get props => [noticeId];
}
