import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/history_transaction_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryOrderRepository {
  Future<Either<Failure, List<HistoryModel>>> getHistoryOrders() async {
    try {
      List<dynamic> response = await supabase.rpc(
        get: true,
        'get_orders_by_id',
        params: {'user_id_param': user.currentUser?.id},
      );

      log(response.toString());

      final products = (response).map((e) => HistoryModel.fromJson(e)).toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(handleError(e));
    } catch (e) {
      return left(handleError(e));
    }
  }

  Future<Either<Failure, bool>> uploadPaymentProofs({
    required int orderId,
    required List<String> paymentProof,
  }) async {
    try {
      final updates = {'payment_proofs': paymentProof};

      await supabase
          .from('orders')
          .update(updates)
          .eq('id', orderId)
          .select()
          .single();

      await supabase
          .from('orders')
          .select()
          .eq('id', orderId)
          .select()
          .single();

      return right(true);
    } on PostgrestException catch (e) {
      return left(handleError(e));
    } catch (e) {
      return left(handleError(e));
    }
  }
}
