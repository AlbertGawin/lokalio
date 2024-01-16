part of 'read_notice_bloc.dart';

sealed class ReadNoticeEvent extends Equatable {
  const ReadNoticeEvent();

  @override
  List<Object> get props => [];
}

final class ReadNoticeDetailsEvent extends ReadNoticeEvent {
  final String noticeId;

  const ReadNoticeDetailsEvent({required this.noticeId});

  @override
  List<Object> get props => [noticeId];
}
