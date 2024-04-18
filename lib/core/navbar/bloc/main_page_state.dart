part of 'main_page_bloc.dart';

abstract class MainPageState {
  final int tabIndex;

  const MainPageState({required this.tabIndex});
}

class MainPageInitial extends MainPageState {
  const MainPageInitial({required super.tabIndex});
}
