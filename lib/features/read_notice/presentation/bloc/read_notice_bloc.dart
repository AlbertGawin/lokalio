import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/usecases/get_notice_details.dart';

part 'read_notice_event.dart';
part 'read_notice_state.dart';

class ReadNoticeBloc extends Bloc<ReadNoticeEvent, ReadNoticeState> {
  final GetNoticeDetails getNoticeDetails;

  ReadNoticeBloc({
    required this.getNoticeDetails,
  }) : super(ReadNoticeInitial()) {
    on<ReadNoticeEvent>((event, emit) async {
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
