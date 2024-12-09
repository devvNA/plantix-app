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
    } on AuthException catch (error) {
      log(error.message);
      return left(error.message);
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
        data: {
          "name": name,
          "avatar_url": avatarUrl,
        },
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

  //   Future<Either<Failure, String>> register({
  //   required String email,
  //   required String password,
  //   required String namaOutlet,
  //   required String alamatOutlet,
  //   // String? serialNumber,
  // }) async {
  //   try {
  //     final request = Request();

  //     final response = await request.post(
  //       registerUser,
  //       data: {
  //         "email": email,
  //         "password": password,
  //         "nama_outlet": namaOutlet,
  //         "alamat": alamatOutlet,
  //         // "serial_number": serialNumber,
  //       },
  //     );
  //     if (response.statusCode == 201) {
  //       return Right(response.data['user'].toString());
  //     }
  //     return const Left(ParsingFailure("Kesalahan Parsing"));
  //   } on DioException catch (e) {
  //     return Left(Exception(e.response!.data["errors"]["email"][0].toString()));
  //   }
  // }
}
