import 'package:fpdart/fpdart.dart';
import 'package:inapp_sms/core/error/failure.dart';
import 'package:inapp_sms/core/usecase/usecase.dart';
import 'package:inapp_sms/feature/auth/domain/repository/auth_repository.dart';
import 'package:inapp_sms/core/entities/user.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin({required this.authRepository});
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
