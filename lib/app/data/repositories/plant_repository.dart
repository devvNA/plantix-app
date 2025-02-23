// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/plant_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantRepository {
  final userId = supabase.auth.currentSession!.user.id;

  Future<Either<Failure, PlantModel>> getPlant({required int fieldId}) async {
    try {
      final data = await supabase
          .from('plants')
          .select()
          .eq('field_id', fieldId)
          .single();
      final plant = PlantModel.fromJson(data);
      log(plant.toString());
      return right(plant);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, PlantModel>> addPlantToField({
    required int fieldId,
    required String name,
    required String type,
  }) async {
    try {
      final query = {
        'field_id': fieldId,
        'plant_name': name,
        'plant_type': type,
        'created_at': DateTime.now().toIso8601String(),
      };
      final data =
          await supabase.from('plants').insert(query).select().single();
      final plant = PlantModel.fromJson(data);

      if (data != null) {
        await supabase.from('farm_production_analysis').update({
          'user_id': userId,
          'plant_type': name,
        }).eq('field_id', plant.fieldId);
      }

      log(plant.toString());
      return right(plant);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<bool> deletePlant(int plantId, int fieldId) async {
    try {
      await supabase.from('plants').delete().eq('id', plantId);

      await supabase.from('farm_production_analysis').update({
        'user_id': userId,
        'plant_type': null,
      }).eq('field_id', fieldId);

      return true;
    } on PostgrestException catch (e) {
      log(e.message);
      return false;
    }
  }
}
