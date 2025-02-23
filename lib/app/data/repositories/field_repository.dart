// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/field_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FieldRepository {
  Future<Either<Failure, FieldModel>> createField({
    required String fieldName,
    required double size,
    required String address,
  }) async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final query = {
        'user_id': userId,
        'field_name': fieldName,
        'size': size,
        'address': address,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response =
          await supabase.from('fields').insert(query).select().single();
      final field = FieldModel.fromJson(response);

      if (response != null) {
        final date = DateTime.now();
        // Insert data ke Tabel Analisa Hasil Usaha Tani
        await supabase
            .from('farm_production_analysis')
            .insert({
              'user_id': field.userId,
              'field_id': field.id,
              'field_name': field.fieldName,
              'plant_type': null,
              'planting_date': date.toIso8601String(),
              'harvest_date': date.add(Duration(days: 100)).toIso8601String(),
              'harvest_quantity': 0,
              'net_income': 0,
              'expenses': 0
            })
            .select()
            .single();
      }

      return right(field);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, List<FieldModel>>> getMyFields() async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final response =
          await supabase.from('fields').select().eq('user_id', userId);

      final fields = response.map((e) => FieldModel.fromJson(e)).toList();

      log(response.toString());
      return right(fields);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  // Future<Either<Failure, FieldModel>> updateStore({
  //   required String storeName,
  //   required String address,
  //   String? storeImageUrl,
  // }) async {
  //   try {
  //     final userId = supabase.auth.currentSession!.user.id;
  //     final updates = {
  //       'store_name': storeName,
  //       'address': address,
  //       'store_image_url': storeImageUrl,
  //       'updated_at': DateTime.now().toIso8601String(),
  //     };

  //     final data = await supabase
  //         .from('my_store')
  //         .update(updates)
  //         .eq("user_id", userId)
  //         .select()
  //         .single();

  //     final store = FieldModel.fromJson(data);
  //     await userHasStore();
  //     return right(store);
  //   } on PostgrestException catch (e) {
  //     log(e.message);
  //     return left(Exception(e.message));
  //   } catch (e) {
  //     log(e.toString());
  //     return left(Exception(e.toString()));
  //   }
  // }

  Future<bool> deleteField(int id) async {
    try {
      await supabase.from('fields').delete().eq('id', id);
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
