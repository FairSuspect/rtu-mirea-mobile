import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/data/datasources/news_remote.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/data/repositories/news_repository_impl.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/delete_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_active_group.dart';
import 'package:rtu_mirea_app/domain/usecases/get_downloaded_schedules.dart';
import 'package:rtu_mirea_app/domain/usecases/get_groups.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news_tags.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/set_active_group.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/onboarding_cubit/onboarding_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/schedule_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // BloC / Cubit
  getIt.registerFactory(
    () => ScheduleBloc(
      getSchedule: getIt(),
      getActiveGroup: getIt(),
      getGroups: getIt(),
      setActiveGroup: getIt(),
      getDownloadedSchedules: getIt(),
      deleteSchedule: getIt(),
    ),
  );
  getIt.registerFactory(
    () => NewsBloc(
      getNews: getIt(),
      getNewsTags: getIt(),
    ),
  );
  getIt.registerFactory(() => HomeNavigatorBloc());
  getIt.registerFactory(() => OnboardingCubit());
  getIt.registerFactory(() => MapCubit());

  // Usecases
  getIt.registerLazySingleton(() => GetGroups(getIt()));
  getIt.registerLazySingleton(() => GetSchedule(getIt()));
  getIt.registerLazySingleton(() => SetActiveGroup(getIt()));
  getIt.registerLazySingleton(() => GetActiveGroup(getIt()));
  getIt.registerLazySingleton(() => GetDownloadedSchedules(getIt()));
  getIt.registerLazySingleton(() => DeleteSchedule(getIt()));
  getIt.registerLazySingleton(() => GetNews(getIt()));
  getIt.registerLazySingleton(() => GetNewsTags(getIt()));

  // Repositories
  getIt.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      connectionChecker: getIt(),
    ),
  );
  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: getIt(),
      connectionChecker: getIt(),
    ),
  );

  getIt.registerLazySingleton<ScheduleRemoteData>(
      () => ScheduleRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<ScheduleLocalData>(
      () => ScheduleLocalDataImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<NewsRemoteData>(
      () => NewsRemoteDataImpl(httpClient: getIt()));

  // Common / Core

  // External Dependency
  getIt.registerLazySingleton(() => Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
