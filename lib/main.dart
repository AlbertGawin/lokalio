import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalio/features/auth/auth.dart';

import 'core/bloc/bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp();

  final authenticationRepository = AuthRepositoryImpl();
  await authenticationRepository.user.first;

  runApp(AuthPage(repository: authenticationRepository));
}
