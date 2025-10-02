import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inapp_sms/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:inapp_sms/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inapp_sms/feature/auth/presentation/pages/login_page.dart';
import 'package:inapp_sms/core/theme/theme.dart';
import 'package:inapp_sms/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:inapp_sms/feature/blog/presentation/pages/blog_page.dart';
import 'package:inapp_sms/init_dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InApp SMS Messaging',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
