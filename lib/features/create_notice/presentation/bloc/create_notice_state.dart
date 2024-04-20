part of 'create_notice_bloc.dart';

final class CreateNoticeState extends Equatable {
  final Images images;
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
    this.images = const Images.pure(),
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
      : this(status: FormzSubmissionStatus.inProgress);

  const CreateNoticeState.success()
      : this(status: FormzSubmissionStatus.success, isValid: true);

  const CreateNoticeState.failure({String? errorMessage})
      : this(errorMessage: errorMessage);

  NoticeDetails get noticeDetails => NoticeDetails(
        id: '',
        userId: '',
        title: title.value,
        category: category.value,
        moneyAmount: int.parse(moneyAmount.value),
        location: location,
        description: description.value,
        peopleAmount: int.parse(peopleAmount.value),
        imagesUrl: images.value,
        createdAt: Timestamp.now().millisecondsSinceEpoch.toString(),
      );

  @override
  List<Object?> get props => [
        images,
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
    Images? images,
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
      images: images ?? this.images,
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
