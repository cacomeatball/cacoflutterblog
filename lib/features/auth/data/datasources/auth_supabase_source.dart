import 'package:caco_flutter_blog/core/error/exception.dart';
import 'package:caco_flutter_blog/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthSupabaseSource {
  Future<UserModel> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthSupabaseSourceImpl implements AuthSupabaseSource {
  final SupabaseClient supabaseClient;
  AuthSupabaseSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async { 
    try {
      final response = await supabaseClient.auth.signUp(
        password: password, 
        email: email, 
        data: {
          'username': username,
        }
      );
      if (response.user == null) {
        throw const ServerException('Failed to sign up user');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async { 
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password, 
        email: email, 
      );
      if (response.user == null) {
        throw const ServerException('User does not exist!');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}   