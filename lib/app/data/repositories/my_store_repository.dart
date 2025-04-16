import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/product_model.dart';
import 'package:plantix_app/app/data/models/store_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      };

      final data =
          await supabase.from('my_stores').insert(updates).select().single();

      final store = MyStoreModel.fromJson(data);
      await userHasStore();
      return right(store);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
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

      final data =
          await supabase
              .from('my_stores')
              .update(updates)
              .eq("user_id", userId)
              .select()
              .single();

      final store = MyStoreModel.fromJson(data);
      await userHasStore();
      return right(store);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<bool> userHasStore() async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final updates = {'has_store': true};

      await supabase
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      log('Toko Berhasil Dibuat');
      return true;
    } on PostgrestException catch (e) {
      log(e.message);
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Either<Failure, MyStoreModel>> getMyStore() async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final data =
          await supabase
              .from('my_stores')
              .select()
              .eq('user_id', userId)
              .single();
      final store = MyStoreModel.fromJson(data);
      log("Store: ${store.toJson()}");
      return right(store);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, ProductModel>> addProductToStore({
    required int storeId,
    required String name,
    required String description,
    required int price,
    required int stock,
    required String category,
    required List<String> imageUrl,
  }) async {
    try {
      final query = {
        "store_id": storeId,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category": category,
        "image_url": imageUrl,
      };
      final data =
          await supabase.from('products').insert(query).select().single();
      final product = ProductModel.fromJson(data);

      log(product.toJson().toString());

      return right(product);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, ProductModel>> updateProduct({
    required int productId,
    // required int storeId,
    required String name,
    required String description,
    required num price,
    required int stock,
    required String category,
    required List<String> imageUrl,
  }) async {
    try {
      final query = {
        // "store_id": storeId,
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "category": category,
        "image_url": imageUrl,
      };

      final data =
          await supabase
              .from('products')
              .update(query)
              .eq("id", productId)
              .select()
              .single();
      final product = ProductModel.fromJson(data);
      log(product.toJson().toString());
      return right(product);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, List<ProductModel>>> getProductsByStoreId({
    required int storeId,
  }) async {
    try {
      final data = await supabase
          .from('products')
          .select()
          .eq('store_id', storeId);
      final products = data.map((e) => ProductModel.fromJson(e)).toList();
      return right(products);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }
}
