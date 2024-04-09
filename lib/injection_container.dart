import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lokalio/core/cache/cache.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/auth/auth.dart';
import 'features/create_notice/create_notice.dart';
import 'features/notice_list/notice_list.dart';
import 'features/profile/profile.dart';
import 'features/read_notice/read_notice.dart';

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

  // Use cases
  sl.registerLazySingleton(() => SignIn(authRepository: sl()));
  sl.registerLazySingleton(() => SignInAnonymously(authRepository: sl()));
  sl.registerLazySingleton(() => SignUp(authRepository: sl()));
  sl.registerLazySingleton(() => SignOut(authRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() =>
      AuthRepositoryImpl(cache: sl(), firebaseAuth: sl(), googleSignIn: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() =>
      AuthRemoteDataSourceImpl(firebaseAuth: sl(), firebaseFirestore: sl()));
}

void initCreateNotice() {
  //Bloc
  sl.registerFactory(() => CreateNoticeBloc(createNotice: sl()));

  // Use cases
  sl.registerLazySingleton(() => CreateNotice(repository: sl()));

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
  sl.registerFactory(() => ProfileBloc(readProfile: sl()));

  // Use cases
  sl.registerLazySingleton(() => ReadProfile(repository: sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(() =>
      ProfileRemoteDataSourceImpl(firebaseFirestore: sl(), firebaseAuth: sl()));
}

void initReadNotice() {
  //Bloc
  sl.registerFactory(() => ReadNoticeBloc(readNotice: sl()));

  // Use cases
  sl.registerLazySingleton(() => ReadNotice(repository: sl()));

  // Repository
  sl.registerLazySingleton<ReadNoticeRepository>(() =>
      ReadNoticeRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<ReadNoticeRemoteDataSource>(
      () => ReadNoticeRemoteDataSourceImpl(firebaseFirestore: sl()));
}

void initNoticeList() {
  //Bloc
  sl.registerFactory(() => NoticeListBloc(repository: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAllNotices(noticeListRepository: sl()));
  sl.registerLazySingleton(() => GetUserNotices(noticeListRepository: sl()));

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
