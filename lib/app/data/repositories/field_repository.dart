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
          await supabase.from('fields').select().eq('user_id', userId).select();

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

  Future<Either<Failure, FieldModel>> addPlantToField({
    required int fieldId,
    required String plantName,
    required String plantType,
  }) async {
    try {
      final query = {
        'field_id': fieldId,
        'plant_name': plantName,
        'plant_type': plantType,
      };

      final data =
          await supabase.from('plants').insert(query).select().single();

      final field = FieldModel.fromJson(data);
      return right(field);
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
