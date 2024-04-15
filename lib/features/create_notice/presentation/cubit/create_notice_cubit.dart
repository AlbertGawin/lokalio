import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/create_notice/presentation/src/category.dart';
import 'package:lokalio/features/create_notice/presentation/src/description.dart';
import 'package:lokalio/features/create_notice/presentation/src/money_amount.dart';
import 'package:lokalio/features/create_notice/presentation/src/people_amount.dart';
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

  void categoryChanged(int value) {
    final category = Category.dirty(value);
    emit(
      state.copyWith(
        category: category,
        isValid: Formz.validate([category]),
      ),
    );
  }

  void moneyAmountChanged(String value) {
    final moneyAmount = MoneyAmount.dirty(value);
    emit(
      state.copyWith(
        moneyAmount: moneyAmount,
        isValid: Formz.validate([moneyAmount]),
      ),
    );
  }

  void peopleAmountChanged(String value) {
    final peopleAmount = PeopleAmount.dirty(value);
    emit(
      state.copyWith(
        peopleAmount: peopleAmount,
        isValid: Formz.validate([peopleAmount]),
      ),
    );
  }
}
