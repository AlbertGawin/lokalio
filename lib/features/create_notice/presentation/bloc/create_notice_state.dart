part of 'create_notice_bloc.dart';

final class CreateNoticeState extends Equatable {
  final List<String> imageUrls;
  final Title title;
  final Description description;
  final Category category;
  final MoneyAmount moneyAmount;
  final PeopleAmount peopleAmount;
  final LatLng location;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const CreateNoticeState({
    this.imageUrls = const [],
    this.title = const Title.pure(),
    this.description = const Description.pure(),
    this.category = const Category.pure(),
    this.moneyAmount = const MoneyAmount.pure(),
    this.peopleAmount = const PeopleAmount.pure(),
    this.location = const LatLng(0, 0),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  const CreateNoticeState.initial() : this();

  const CreateNoticeState.loading()
      : this(
          status: FormzSubmissionStatus.inProgress,
        );

  const CreateNoticeState.success()
      : this(
          status: FormzSubmissionStatus.success,
          isValid: true,
        );

  const CreateNoticeState.failure({String? errorMessage})
      : this(errorMessage: errorMessage);

  @override
  List<Object?> get props => [
        imageUrls,
        title,
        description,
        category,
        moneyAmount,
        peopleAmount,
        location,
        status,
        isValid,
        errorMessage,
      ];

  CreateNoticeState copyWith({
    List<String>? imageUrls,
    Title? title,
    Description? description,
    Category? category,
    MoneyAmount? moneyAmount,
    PeopleAmount? peopleAmount,
    LatLng? location,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return CreateNoticeState(
      imageUrls: imageUrls ?? this.imageUrls,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      moneyAmount: moneyAmount ?? this.moneyAmount,
      peopleAmount: peopleAmount ?? this.peopleAmount,
      location: location ?? this.location,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
