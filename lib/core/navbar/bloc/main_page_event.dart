part of 'main_page_bloc.dart';

sealed class MainPageEvent extends Equatable {
  const MainPageEvent();

  @override
  List<Object> get props => [];
}

final class TabChangeEvent extends MainPageEvent {
  final int tabIndex;

  const TabChangeEvent({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}
