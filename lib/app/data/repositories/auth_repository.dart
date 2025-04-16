import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  Future<Either<String, AuthResponse>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return right(response);
    } on AuthException catch (e) {
      String message = '';
      log(e.code.toString());

      if (e.code == 'invalid_credentials') {
        message = 'Email atau password salah';
      }

      return left(message);
    } catch (e) {
      log(e.toString());
      return left(e.toString());
    }
  }

  Future<Either<String, AuthResponse>> registerWithEmailPassword({
    required String email,
    required String password,
    required String name,
    String? avatarUrl,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {"name": name, "avatar_url": avatarUrl},
      );
      return right(response);
    } on AuthException catch (error) {
      log(error.message);
      return left(error.message);
    } catch (e) {
      log(e.toString());
      return left(e.toString());
    }
  }
}
