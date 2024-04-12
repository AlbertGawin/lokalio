part of 'notice_bloc.dart';

enum NoticeStatus { loading, success, failure }

final class NoticeState extends Equatable {
  final NoticeStatus status;
  final NoticeDetails noticeDetails;

  const NoticeState._({
    required this.status,
    this.noticeDetails = NoticeDetails.empty,
  });

  const NoticeState.loading() : this._(status: NoticeStatus.loading);

  const NoticeState.success({required NoticeDetails notice})
      : this._(status: NoticeStatus.success, noticeDetails: notice);

  const NoticeState.failure() : this._(status: NoticeStatus.failure);

  @override
  List<Object> get props => [status, noticeDetails];
}
