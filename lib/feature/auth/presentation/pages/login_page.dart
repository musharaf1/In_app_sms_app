import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inapp_sms/core/theme/app_pallet.dart';
import 'package:inapp_sms/core/utils/show_snackbar.dart';
import 'package:inapp_sms/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:inapp_sms/feature/auth/presentation/pages/signup_page.dart';
import 'package:inapp_sms/feature/auth/presentation/widgets/auth_field.dart';
import 'package:inapp_sms/feature/auth/presentation/widgets/auth_gradient_button.dart';

import '../../../../core/common/widgets/loader.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) {
      return LoginPage();
    },
  );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();

    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            }

            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign In.',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  AuthField(
                    hintText: 'Email',
                    editingController: emailController,
                  ),
                  SizedBox(height: 15),
                  AuthField(
                    hintText: 'Password',
                    editingController: passwordController,
                    isObscureText: true,
                  ),
                  SizedBox(height: 20),
                  AuthGradientButton(
                    buttonText: "Sign In",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          AuthLogin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => Navigator.push(context, SignUpPage.route()),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account ? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppPallet.contentPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
