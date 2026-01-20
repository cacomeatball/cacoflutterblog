import 'package:caco_flutter_blog/core/error/failure.dart';
import 'package:caco_flutter_blog/core/usecase/usecase.dart';
import 'package:caco_flutter_blog/core/common/entities/user.dart';
import 'package:caco_flutter_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignup implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignup(this.authRepository);  

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      username: params.username, 
      email: params.email, 
      password: params.password
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String username;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.username,
  });
}