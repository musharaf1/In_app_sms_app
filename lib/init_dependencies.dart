import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:inapp_sms/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:inapp_sms/core/network/connection_checker.dart';
import 'package:inapp_sms/core/secret/app_secret.dart';
import 'package:inapp_sms/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:inapp_sms/feature/auth/data/repositories/auth_repositories_impl.dart';
import 'package:inapp_sms/feature/auth/domain/repository/auth_repository.dart';
import 'package:inapp_sms/feature/auth/domain/repository/usecases/current_user.dart';
import 'package:inapp_sms/feature/auth/domain/repository/usecases/user_login.dart';
import 'package:inapp_sms/feature/auth/domain/repository/usecases/user_sign_up.dart';
import 'package:inapp_sms/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inapp_sms/feature/blog/data/blog_repository_impl.dart';
import 'package:inapp_sms/feature/blog/data/datasources/blog_local_data_source.dart';
import 'package:inapp_sms/feature/blog/data/datasources/blog_remote_data_source.dart';
import 'package:inapp_sms/feature/blog/domain/repositories/blog_repository.dart';
import 'package:inapp_sms/feature/blog/domain/usecase/get_all_blogs.dart';
import 'package:inapp_sms/feature/blog/domain/usecase/upload_blog.dart';
import 'package:inapp_sms/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  final supabase = await Supabase.initialize(
    url: AppSecret.supabaseUrl,
    anonKey: AppSecret.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton<Box>(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initBlog() {
  // Data Source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImp(supabaseClient: serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImp(serviceLocator()),
    )
    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator(),
        blogLocalDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    //UseCase
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    //Bloc
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );
}

void _initAuth() {
  // Data Source
  serviceLocator
    ..registerFactory<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(serviceLocator()),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoriesImpl(serviceLocator(), serviceLocator()),
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
