import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:lokalio/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:lokalio/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lokalio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lokalio/features/auth/presentation/pages/auth_page.dart';

import 'package:lokalio/firebase_options.dart';
import 'package:lokalio/injection_container.dart' as di;
import 'package:lokalio/injection_container.dart';

import 'core/bloc/bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  final authenticationRepository = AuthRepositoryImpl(
    remoteDataSource: sl<AuthRemoteDataSource>(),
    localDataSource: sl<AuthLocalDataSource>(),
  );
  await authenticationRepository.profile.first;

  runApp(AuthPage(repository: authenticationRepository));
}
