import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lokalio/core/error/failures.dart';
import 'package:lokalio/features/create_notice/domain/usecases/create_notice.dart';
import 'package:lokalio/features/notice/domain/entities/notice_details.dart';

part 'create_notice_event.dart';
part 'create_notice_state.dart';

class CreateNoticeBloc extends Bloc<CreateNoticeEvent, CreateNoticeState> {
  final CreateNotice createNotice;

  CreateNoticeBloc({required this.createNotice})
      : super(CreateNoticeInitial()) {
    on<CreateNoticeEvent>((event, emit) async {
      if (event is CreateNoticeDetailsEvent) {
        emit(Loading());
        await createNotice(Params(noticeDetails: event.noticeDetails))
            .then((isCreated) {
          isCreated.fold(
            (failure) => emit(Error(message: failureMessages[failure.type]!)),
            (isCreated) => emit(Done()),
          );
        });
      }
    });
  }
}
