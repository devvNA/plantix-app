import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/user_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final userId = supabase.auth.currentSession!.user.id;

  Future<Either<Failure, String>> onUploadAvatar(String imageUrl) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase
          .from('users')
          .update({"avatar_url": imageUrl})
          .eq('id', userId)
          .select();
      await user.loadUserData();
      return right("Berhasil mengubah foto profil");
    } on PostgrestException catch (error) {
      return left(Exception(error.message));
    } catch (error) {
      return left(Exception(error.toString()));
    }
  }

  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final response =
          await supabase.from('users').select().eq('id', userId).single();

      final user = UserModel.fromJson(response);
      log("User: ${user.toJson()}");
      return right(user);

      // return const Left(ParsingFailure("Kesalahan Parsing"));
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
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

      final response =
          await supabase
              .from('users')
              .update(updates)
              .eq('id', userId)
              .select()
              .single();

      UserModel updatedUser = UserModel.fromJson(response);
      return right(updatedUser);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, User?>> updateUserEmail(String newEmail) async {
    try {
      final response = await supabase.auth.updateUser(
        UserAttributes(email: newEmail),
      );
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
}
