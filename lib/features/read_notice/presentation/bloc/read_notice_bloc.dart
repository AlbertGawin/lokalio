import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/features/read_notice/domain/entities/notice_details.dart';
import 'package:lokalio/features/read_notice/domain/usecases/read_notice.dart';

part 'read_notice_event.dart';
part 'read_notice_state.dart';

class ReadNoticeBloc extends Bloc<ReadNoticeEvent, ReadNoticeState> {
  final ReadNotice readNotice;

  ReadNoticeBloc({required this.readNotice}) : super(ReadNoticeInitial()) {
    on<ReadNoticeEvent>((event, emit) async {
      if (event is ReadNoticeDetailsEvent) {
        emit(Loading());
        await readNotice(Params(noticeId: event.noticeId))
            .then((noticeDetails) {
          emit(Done(noticeDetails: noticeDetails));
        });
      }
    });
  }
}
