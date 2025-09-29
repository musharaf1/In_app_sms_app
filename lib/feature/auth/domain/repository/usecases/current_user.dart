import 'package:fpdart/fpdart.dart';
import 'package:inapp_sms/core/error/failure.dart';
import 'package:inapp_sms/core/usecase/usecase.dart';
import 'package:inapp_sms/feature/auth/domain/repository/auth_repository.dart';
import 'package:inapp_sms/core/entities/user.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.getCurrentUser();
  }
}
