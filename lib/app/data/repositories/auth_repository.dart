import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/user_model.dart';
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
    required String address,
    required String phoneNumber,
    required String photoUrl,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        data: {
          "name": name,
          "address": address,
          "phone_number": phoneNumber,
          "photo_url": photoUrl,
          "has_store": false,
        },
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

  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final data = supabase.auth.currentSession?.user.userMetadata;
      UserModel user = UserModel.fromJson(data ?? {});
      log(user.toJson().toString());
      return right(user);

      // return const Left(ParsingFailure("Kesalahan Parsing"));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
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

class UserManager {
  // Singleton instance
  static final UserManager instance = UserManager._internal();
  
  // Private constructor
  UserManager._internal();

  // Menyimpan data user saat ini
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Memuat data user dari repository
  Future<void> loadUserData() async {
    final response = await AuthRepository().getUser();
    response.fold(
      (failure) {
        log('Gagal memuat data user: ${failure.message}');
        _currentUser = null;
      },
      (user) => _currentUser = user,
    );
  }

  // Mengecek apakah user memiliki toko
  bool hasStore() {
    return _currentUser?.hasStore ?? false;
  }

  // Reset data user
  void clearUser() {
    _currentUser = null;
  }
}
