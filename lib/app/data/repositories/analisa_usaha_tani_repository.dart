import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/analisa_usaha_model.dart';
import 'package:plantix_app/app/data/models/spend_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalisaUsahaTaniRepository {
  final userId = supabase.auth.currentSession!.user.id;

  Future<Either<Failure, List<FarmingProductionAnalysisModel>>>
      getAnalisaUsahaTani() async {
    try {
      final response = await supabase
          .from('farm_production_analysis')
          .select()
          .eq('user_id', userId);

      final data = response
          .map((e) => FarmingProductionAnalysisModel.fromJson(e))
          .toList();

      log(response.toString());
      return right(data);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, List<SpendModel>>> getSpend(int farmAnalysisId) async {
    try {
      final response = await supabase
          .from('spends')
          .select()
          .eq('farm_analysis_id', farmAnalysisId);

      final data = response.map((e) => SpendModel.fromJson(e)).toList();
      log(data.toString());
      return right(data);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, SpendModel>> createSpend(
      {required int farmAnalysisId,
      required String spendName,
      required int amount}) async {
    try {
      final query = {
        "spend_name": spendName,
        "amount": amount,
        "farm_analysis_id": farmAnalysisId,
      };

      final response =
          await supabase.from('spends').insert(query).select().single();

      final data = SpendModel.fromJson(response);

      return right(data);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<bool> deleteSpend(int spendId) async {
    try {
      await supabase.from('spends').delete().eq('id', spendId);

      return true;
    } on PostgrestException catch (e) {
      log(e.message);
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> updateHarvestAnalysis({
    required int farmAnalysisId,
    required int harvestQuantity,
    required int netIncome,
    required int expenses,
  }) async {
    try {
      final query = {
        'user_id': userId,
        'harvest_quantity': harvestQuantity,
        'net_income': netIncome,
        'expenses': expenses,
      };

      await supabase
          .from('farm_production_analysis')
          .update(query)
          .eq('id', farmAnalysisId);

      return true;
    } on PostgrestException catch (e) {
      log(e.message);
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
