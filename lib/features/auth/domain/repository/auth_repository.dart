import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> currentUser();
}