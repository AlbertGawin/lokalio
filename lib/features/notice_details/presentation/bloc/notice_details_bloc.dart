import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/notice_crud/domain/entities/notice_details.dart';
import 'package:lokalio/features/notice_details/domain/usecases/get_notice_details.dart';

part 'notice_details_event.dart';
part 'notice_details_state.dart';

class NoticeDetailsBloc extends Bloc<NoticeDetailsEvent, NoticeDetailsState> {
  final GetNoticeDetails getNoticeDetails;

  NoticeDetailsBloc({
    required this.getNoticeDetails,
  }) : super(NoticeDetailsInitial()) {
    on<NoticeDetailsEvent>((event, emit) async {
      if (event is GetNoticeDetailsEvent) {
        emit(Loading());
        await getNoticeDetails(Params(noticeId: event.noticeId))
            .then((noticeDetails) {
          noticeDetails.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (noticeDetails) => emit(Done(noticeDetails: noticeDetails)),
          );
        });
      }
    });
  }
}
