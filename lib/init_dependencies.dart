import 'package:get_it/get_it.dart';
import 'package:inapp_sms/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:inapp_sms/core/secret/app_secret.dart';
import 'package:inapp_sms/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:inapp_sms/feature/auth/data/repositories/auth_repositories_impl.dart';
import 'package:inapp_sms/feature/auth/domain/repository/auth_repository.dart';
import 'package:inapp_sms/feature/auth/domain/repository/usecases/current_user.dart';
import 'package:inapp_sms/feature/auth/domain/repository/usecases/user_login.dart';
import 'package:inapp_sms/feature/auth/domain/repository/usecases/user_sign_up.dart';
import 'package:inapp_sms/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();

  final supabase = await Supabase.initialize(
    url: AppSecret.supabaseUrl,
    anonKey: AppSecret.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // Data Source
  serviceLocator
    ..registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(serviceLocator()),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoriesImpl(serviceLocator()),
    )
    //UseCase
    ..registerFactory(() => UserSignUp(serviceLocator()))
    //UseCase
    ..registerFactory(() => UserLogin(authRepository: serviceLocator()))
    ..registerFactory(() => CurrentUser(authRepository: serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}
