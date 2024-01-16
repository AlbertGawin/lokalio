import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lokalio/core/network/network_info.dart';
import 'package:lokalio/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lokalio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_in.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_out.dart';
import 'package:lokalio/features/auth/domain/usecases/sign_up.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/create_notice/data/datasources/create_notice_local_data_source.dart';
import 'package:lokalio/features/create_notice/data/datasources/create_notice_remote_data_source.dart';
import 'package:lokalio/features/create_notice/data/repositories/create_notice_repository_impl.dart';
import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/create_notice/domain/usecases/create_notice.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/read_notice/data/datasources/read_notice_local_data_source.dart';
import 'package:lokalio/features/read_notice/data/datasources/read_notice_remote_data_source.dart';
import 'package:lokalio/features/read_notice/data/repositories/read_notice_repository_impl.dart';
import 'package:lokalio/features/read_notice/domain/repositories/read_notice_repository.dart';
import 'package:lokalio/features/read_notice/domain/usecases/read_notice.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_local_data_source.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_remote_data_source.dart';
import 'package:lokalio/features/notice_list/data/repositories/notice_list_repository_impl.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_all_notices.dart';
import 'package:lokalio/features/notice_list/domain/usecases/get_user_notices.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/read_notice/presentation/bloc/read_notice_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  initAuth();
  initCreateNotice();
  initNoticeList();
  initReadNotice();
  initCore();
  await initExternal();
}

void initAuth() {
  //Bloc
  sl.registerFactory(() => AuthBloc(signIn: sl(), signUp: sl(), signOut: sl()));

  // Use cases
  sl.registerLazySingleton(() => SignIn(authRepository: sl()));
  sl.registerLazySingleton(() => SignUp(authRepository: sl()));
  sl.registerLazySingleton(() => SignOut(authRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(firebaseAuth: sl()));
}

void initCreateNotice() {
  //Bloc
  sl.registerFactory(() => CreateNoticeBloc(createNotice: sl()));

  // Use cases
  sl.registerLazySingleton(() => CreateNotice(repository: sl()));

  // Repository
  sl.registerLazySingleton<CreateNoticeRepository>(() =>
      CreateNoticeRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<CreateNoticeRemoteDataSource>(
      () => CreateNoticeRemoteDataSourceImpl(firebaseFirestore: sl()));
  sl.registerLazySingleton<CreateNoticeLocalDataSource>(
      () => CreateNoticeLocalDataSourceImpl(sharedPreferences: sl()));
}

void initReadNotice() {
  //Bloc
  sl.registerFactory(() => ReadNoticeBloc(readNotice: sl()));

  // Use cases
  sl.registerLazySingleton(() => ReadNotice(repository: sl()));

  // Repository
  sl.registerLazySingleton<ReadNoticeRepository>(() => ReadNoticeRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<ReadNoticeRemoteDataSource>(
      () => ReadNoticeRemoteDataSourceImpl(firebaseFirestore: sl()));
  sl.registerLazySingleton<ReadNoticeLocalDataSource>(
      () => ReadNoticeLocalDataSourceImpl(sharedPreferences: sl()));
}

void initNoticeList() {
  //Bloc
  sl.registerFactory(
      () => NoticeListBloc(getAllNotices: sl(), getUserNotices: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAllNotices(noticeListRepository: sl()));
  sl.registerLazySingleton(() => GetUserNotices(noticeListRepository: sl()));

  // Repository
  sl.registerLazySingleton<NoticeListRepository>(() => NoticeListRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<NoticeListRemoteDataSource>(() =>
      NoticeListRemoteDataSourceImpl(
          firebaseFirestore: sl(), firebaseAuth: sl()));
  sl.registerLazySingleton<NoticeListLocalDataSource>(
      () => NoticeListLocalDataSourceImpl(sharedPreferences: sl()));
}

void initCore() {
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
        internetConnectionChecker: sl(),
      ));
}

Future<void> initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
