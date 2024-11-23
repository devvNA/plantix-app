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

  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
          await supabase.from('users').select().eq('id', userId).single();
      UserModel user = UserModel.fromJson(data);
      log(user.toJson().toString());
      return right(user);

      // return const Left(ParsingFailure("Kesalahan Parsing"));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> updateUserData({
    String? name,
    String? email,
    String? address,
    String? phoneNumber,
    String? storeName,
  }) async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final updates = {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (address != null) 'address': address,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (storeName != null) 'store_name': storeName,
      };

      final data = await supabase
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      UserModel updatedUser = UserModel.fromJson(data);
      return right(updatedUser);
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, User?>> updateUserEmail(String newEmail) async {
    try {
      final response =
          await supabase.auth.updateUser(UserAttributes(email: newEmail));
      if (response.user != null) {
        updateUserData(email: newEmail);
        return right(response.user);
      }
      return left(Exception('Gagal memperbarui email'));
    } on AuthException catch (e) {
      log(e.message);
      return left(Exception(e.message));
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

  // Reset data user
  void clearUser() {
    _currentUser = null;
  }
}
