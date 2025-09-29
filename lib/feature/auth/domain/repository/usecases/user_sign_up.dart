import 'package:fpdart/fpdart.dart';
import 'package:inapp_sms/core/error/failure.dart';
import 'package:inapp_sms/core/usecase/usecase.dart';
import 'package:inapp_sms/feature/auth/domain/repository/auth_repository.dart';
import 'package:inapp_sms/core/entities/user.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  AuthRepository authRepository;
  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
