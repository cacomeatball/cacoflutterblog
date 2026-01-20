import 'package:caco_flutter_blog/core/secrets/supabaseEnv.dart';
import 'package:caco_flutter_blog/features/auth/data/datasources/auth_supabase_source.dart';
import 'package:caco_flutter_blog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:caco_flutter_blog/features/auth/domain/repository/auth_repository.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/current_user.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/user_logIn.dart';
import 'package:caco_flutter_blog/features/auth/domain/usecases/user_signUp.dart';
import 'package:caco_flutter_blog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: SupabaseEnv.supabaseUrl, 
    anonKey: SupabaseEnv.supabaseKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator
  ..registerFactory<AuthSupabaseSource>(
    () => AuthSupabaseSourceImpl(
      serviceLocator(),
    ),
  )
  ..registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => UserSignup(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  )
  ..registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  )
  ..registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogIn: serviceLocator(),
      currentUser: serviceLocator(),
    ),
  );
}