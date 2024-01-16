part of 'create_notice_bloc.dart';

sealed class CreateNoticeEvent extends Equatable {
  const CreateNoticeEvent();

  @override
  List<Object> get props => [];
}

final class CreateNoticeDetailsEvent extends CreateNoticeEvent {
  final NoticeDetails noticeDetails;

  const CreateNoticeDetailsEvent({required this.noticeDetails});

  @override
  List<Object> get props => [noticeDetails];
}
