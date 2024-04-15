import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/create_notice/presentation/src/category.dart';
import 'package:lokalio/features/create_notice/presentation/src/description.dart';
import 'package:lokalio/features/create_notice/presentation/src/money_amount.dart';
import 'package:lokalio/features/create_notice/presentation/src/people_amount.dart';
import 'package:lokalio/features/create_notice/presentation/src/title.dart';
import 'package:lokalio/features/notice/domain/entities/notice_details.dart';

part 'create_notice_event.dart';
part 'create_notice_state.dart';

class CreateNoticeBloc extends Bloc<CreateNoticeEvent, CreateNoticeState> {
  final CreateNoticeRepository _repository;

  CreateNoticeBloc({required CreateNoticeRepository repository})
      : _repository = repository,
        super(const CreateNoticeState.initial()) {
    on<CreateNoticeEvent>((event, emit) async {
      if (event is CreateNoticeDetailsEvent) {
        await _repository
            .createNotice(noticeDetails: event.noticeDetails)
            .then((chooser) {
          chooser.fold(
            (failure) => emit(const CreateNoticeState.failure()),
            (_) => emit(const CreateNoticeState.success()),
          );
        });
      }
    });
  }
}
