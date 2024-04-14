import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/src/description.dart';
import 'package:lokalio/features/create_notice/presentation/src/title.dart';

class CreateNoticeCubit extends Cubit<CreateNoticeState> {
  CreateNoticeCubit() : super(const CreateNoticeState());

  void titleChanged(String value) {
    final title = Title.dirty(value);
    emit(
      state.copyWith(
        title: title,
        isValid: Formz.validate([title]),
      ),
    );
  }

  void descriptionChanged(String value) {
    final description = Description.dirty(value);
    emit(
      state.copyWith(
        description: description,
        isValid: Formz.validate([description]),
      ),
    );
  }
}
