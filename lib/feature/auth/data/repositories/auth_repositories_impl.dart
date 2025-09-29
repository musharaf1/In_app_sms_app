import 'package:inapp_sms/core/error/exception.dart';
import 'package:inapp_sms/core/error/failure.dart';
import 'package:inapp_sms/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:inapp_sms/feature/auth/data/model/user_model.dart';
import 'package:inapp_sms/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inapp_sms/core/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoriesImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoriesImpl(this.authRemoteDatasource);

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await authRemoteDatasource.getCurrentUserData();

      if (user == null) {
        return left(Failure('User not logged in'));
      }

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => authRemoteDatasource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => authRemoteDatasource.signUpwWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<UserModel> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
