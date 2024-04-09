import 'package:flutter/widgets.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/auth/presentation/pages/signin_page.dart';
import 'package:lokalio/features/notice_list/presentation/pages/home_page.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AuthStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AuthStatus.authenticated:
      return [HomePage.page()];
    case AuthStatus.unauthenticated:
      return [SignInPage.page()];
  }
}
