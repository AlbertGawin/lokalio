import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lokalio/core/cache/cache.dart';
import 'package:lokalio/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lokalio/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lokalio/features/auth/domain/repositories/auth_repository.dart';
import 'package:lokalio/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lokalio/features/create_notice/data/datasources/create_notice_remote_data_source.dart';
import 'package:lokalio/features/create_notice/data/repositories/create_notice_repository_impl.dart';
import 'package:lokalio/features/create_notice/domain/repositories/create_notice_repository.dart';
import 'package:lokalio/features/create_notice/presentation/bloc/create_notice_bloc.dart';
import 'package:lokalio/features/notice/data/datasources/notice_remote_data_source.dart';
import 'package:lokalio/features/notice/data/repositories/notice_repository_impl.dart';
import 'package:lokalio/features/notice/domain/repositories/notice_repository.dart';
import 'package:lokalio/features/notice/presentation/bloc/notice_bloc.dart';
import 'package:lokalio/features/notice_list/data/datasources/notice_list_remote_data_source.dart';
import 'package:lokalio/features/notice_list/data/repositories/notice_list_repository_impl.dart';
import 'package:lokalio/features/notice_list/domain/repositories/notice_list_repository.dart';
import 'package:lokalio/features/notice_list/presentation/bloc/notice_list_bloc.dart';
import 'package:lokalio/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:lokalio/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:lokalio/features/profile/domain/repositories/profile_repository.dart';
import 'package:lokalio/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  initAuth();
  initCreateNotice();
  initNoticeList();
  initProfile();
  initReadNotice();
  initCore();
  await initExternal();
}

void initAuth() {
  //Bloc
  sl.registerFactory(() => AuthBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(cache: sl(), firebaseAuth: sl(), googleSignIn: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() =>
      AuthRemoteDataSourceImpl(firebaseAuth: sl(), firebaseFirestore: sl()));
}

void initCreateNotice() {
  //Bloc
  sl.registerFactory(() => CreateNoticeBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<CreateNoticeRepository>(() =>
      CreateNoticeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<CreateNoticeRemoteDataSource>(() =>
      CreateNoticeRemoteDataSourceImpl(
          firebaseFirestore: sl(), firebaseStorage: sl()));
}

void initProfile() {
  //Bloc
  sl.registerFactory(() => ProfileBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(firebaseFirestore: sl()));
}

void initReadNotice() {
  //Bloc
  sl.registerFactory(() => NoticeBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<NoticeRepository>(
      () => NoticeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<NoticeRemoteDataSource>(
      () => NoticeRemoteDataSourceImpl(firebaseFirestore: sl()));
}

void initNoticeList() {
  //Bloc
  sl.registerFactory(() => NoticeListBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<NoticeListRepository>(() =>
      NoticeListRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<NoticeListRemoteDataSource>(() =>
      NoticeListRemoteDataSourceImpl(
          firebaseFirestore: sl(), firebaseAuth: sl()));
}

void initCore() {
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: sl()));
}

Future<void> initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseStorage);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => CacheClient());
  sl.registerLazySingleton(() => GoogleSignIn());
}
