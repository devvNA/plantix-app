import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/store_model.dart';
import 'package:plantix_app/main.dart';

class MyStoreRepository {
  Future<Either<Failure, MyStoreModel>> createStore({
    required String storeName,
    required String address,
    String? storeImageUrl,
  }) async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final updates = {
        'user_id': userId,
        'store_name': storeName,
        'address': address,
        'store_image_url': storeImageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final data =
          await supabase.from('my_store').insert(updates).select().single();

      final store = MyStoreModel.fromJson(data);
      await userHasStore();
      return right(store);
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, MyStoreModel>> updateStore({
    required String storeName,
    required String address,
    String? storeImageUrl,
  }) async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final updates = {
        'store_name': storeName,
        'address': address,
        'store_image_url': storeImageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final data = await supabase
          .from('my_store')
          .update(updates)
          .eq("user_id", userId)
          .select()
          .single();

      final store = MyStoreModel.fromJson(data);
      await userHasStore();
      return right(store);
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<bool> userHasStore() async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final updates = {
        'has_store': true,
      };

      await supabase
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      log('Toko Berhasil Dibuat');
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Either<Failure, MyStoreModel>> getStore() async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data = await supabase
          .from('my_store')
          .select()
          .eq('user_id', userId)
          .single();
      final store = MyStoreModel.fromJson(data);
      return right(store);
    } catch (e) {
      return left(Exception(e.toString()));
    }
  }
}
