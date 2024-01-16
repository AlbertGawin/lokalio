part of 'read_notice_bloc.dart';

sealed class ReadNoticeEvent extends Equatable {
  const ReadNoticeEvent();

  @override
  List<Object> get props => [];
}

final class GetNoticeDetailsEvent extends ReadNoticeEvent {
  final String noticeId;

  const GetNoticeDetailsEvent({required this.noticeId});

  @override
  List<Object> get props => [noticeId];
}
