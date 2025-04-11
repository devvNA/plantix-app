import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/shop_response_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopRepository {
  Future<Either<Failure, List<ShopResponse>>> getProductExceptStore(
    int currentStoreId,
  ) async {
    try {
      List<dynamic> response = await supabase.rpc(
        'get_product_except_store',
        params: {'id_store': currentStoreId},
      );

      log(response.toString());

      final products = response.map((e) => ShopResponse.fromJson(e)).toList();

      return right(products);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, List<ShopResponse>>> getAllProduct() async {
    try {
      List<dynamic> response = await supabase.rpc('get_all_products');

      log(response.toString());

      final products = response.map((e) => ShopResponse.fromJson(e)).toList();

      return right(products);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Stream<List<ShopResponse>> streamAllProducts() {
    // Buat controller untuk mengelola stream
    final controller = StreamController<List<ShopResponse>>.broadcast();

    // Fungsi untuk memuat data
    void loadData() async {
      try {
        final result = await getAllProduct();
        result.fold(
          (failure) => controller.addError(failure),
          (products) => controller.add(products),
        );
      } catch (e) {
        controller.addError(e);
      }
    }

    // Muat data segera dan siapkan subscription untuk perubahan
    loadData();

    // Set up Supabase realtime subscription
    final subscription =
        supabase
            .channel('public:products')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'products',
              callback: (payload) {
                // Muat ulang data ketika ada perubahan
                loadData();
              },
            )
            .subscribe();

    // Membersihkan resources saat stream ditutup
    controller.onCancel = () {
      subscription.unsubscribe();
      controller.close();
    };

    return controller.stream;
  }

  Stream<List<ShopResponse>> streamProducts(int storeId) {
    // Buat controller untuk mengelola stream
    final controller = StreamController<List<ShopResponse>>.broadcast();

    // Fungsi untuk memuat data
    void loadData() async {
      try {
        final result = await getProductExceptStore(storeId);
        result.fold(
          (failure) => controller.addError(failure),
          (products) => controller.add(products),
        );
      } catch (e) {
        controller.addError(e);
      }
    }

    // Muat data segera dan siapkan subscription untuk perubahan
    loadData();

    // Set up Supabase realtime subscription
    final subscription =
        supabase
            .channel('public:products')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'products',
              callback: (payload) {
                // Muat ulang data ketika ada perubahan
                loadData();
              },
            )
            .subscribe();

    // Membersihkan resources saat stream ditutup
    controller.onCancel = () {
      subscription.unsubscribe();
      controller.close();
    };

    return controller.stream;
  }
}
