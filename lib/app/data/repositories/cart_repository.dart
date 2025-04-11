import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/cart_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartRepository {
  final String userId = supabase.auth.currentSession!.user.id;

  /// Mengambil daftar item di keranjang pengguna
  Future<Either<Failure, List<CartModel>>> getCartByID() async {
    try {
      final response = await supabase.rpc(
        'get_cart_by_user_id',
        params: {'user_id_param': userId},
      );

      log(response.toString());
      final products =
          (response as List).map((e) => CartModel.fromJson(e)).toList();
      return right(products);
    } catch (e) {
      log(e.toString());
      return left(_handleError(e));
    }
  }

  /// Menambahkan item ke keranjang atau memperbarui jumlahnya jika sudah ada
  Future<Either<Failure, bool>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    try {
      // Cek apakah produk sudah ada di keranjang pengguna
      final existingCart = await supabase
          .from('cart')
          .select()
          .eq('product_id', productId)
          .eq('user_id', userId);

      if (existingCart.isEmpty) {
        // Jika belum ada, tambahkan item baru
        await supabase.from('cart').insert({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        });
      } else {
        // Jika sudah ada, update jumlahnya
        final cartItem = existingCart.first;
        final newQuantity = (cartItem['quantity'] as int) + quantity;
        await supabase
            .from('cart')
            .update({'quantity': newQuantity})
            .eq('id', cartItem['id']);
      }

      return right(true);
    } catch (e) {
      log(e.toString());
      return left(_handleError(e));
    }
  }

  /// Mengubah jumlah item di keranjang
  Future<Either<Failure, bool>> updateCartQuantity({
    required int cartId,
    required int quantity,
  }) async {
    try {
      await supabase
          .from('cart')
          .update({'quantity': quantity})
          .eq('id', cartId)
          .eq('user_id', userId);

      return right(true);
    } catch (e) {
      return left(_handleError(e));
    }
  }

  /// Menghapus item dari keranjang
  Future<Either<Failure, bool>> deleteCartItem(int cartId) async {
    try {
      await supabase
          .from('cart')
          .delete()
          .eq('id', cartId)
          .eq('user_id', userId);

      return right(true);
    } catch (e) {
      return left(_handleError(e));
    }
  }

  /// Menangani error dari Supabase dan error umum
  Failure _handleError(dynamic e) {
    if (e is PostgrestException) {
      log(e.message);
      return Exception(e.message);
    }
    return Exception(e.toString());
  }
}
