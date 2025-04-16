import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/cart_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  Future<Either<Failure, bool>> createOrder({
    required List<CartModel> cartList,
    required int totalPrice,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      // Buat pesanan
      final response =
          await supabase
              .from('orders')
              .insert({
                'user_id': user.currentUser?.id,
                'total_price': totalPrice,
                'shipping_address': shippingAddress,
                'payment_method': paymentMethod,
              })
              .select()
              .single();

      final orderId = response['id'];

      // // 3. Tambahkan order_id ke setiap item
      // final itemsWithOrderId =
      //     cartList.map((item) {
      //       return {...item.toJson(), 'order_id': orderId};
      //     }).toList();

      // await supabase.from('order_items').insert(itemsWithOrderId);

      await supabase.from('order_items').insert({
        'order_id': orderId,
        'product_id': cartList.first.productId,
        'quantity': cartList.first.quantity,
      });

      // Kurangi stok produk
      for (var item in cartList) {
        final currentStock = item.stock;
        final newStock = currentStock - item.quantity;
        await supabase
            .from('products')
            .update({'stock': newStock})
            .eq('id', item.productId);
      }

      // Hapus semua item keranjang yang ada dalam pesanan
      for (var item in cartList) {
        await supabase.from('cart').delete().eq('id', item.cartId);
      }

      return right(true);
    } on PostgrestException catch (e) {
      return left(handleError(e));
    } catch (e) {
      return left(handleError(e));
    }
  }
}
