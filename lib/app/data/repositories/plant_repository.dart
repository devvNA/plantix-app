import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/plant_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantRepository {
  Future<Either<Failure, PlantModel>> getPlant({required int fieldId}) async {
    try {
      final data = await supabase
          .from('plants')
          .select()
          .eq('field_id', fieldId)
          .single();
      final plant = PlantModel.fromJson(data);
      log(plant.toJson().toString());
      return right(plant);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, PlantModel>> addPlant({
    required int fieldId,
    required String name,
    required String type,
  }) async {
    try {
      final query = {
        'field_id': fieldId,
        'plant_name': name,
        'plant_type': type,
      };
      final data =
          await supabase.from('plants').insert(query).select().single();
      final plant = PlantModel.fromJson(data);
      log(plant.toJson().toString());
      return right(plant);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<bool> deletePlant(int id) async {
    try {
      await supabase.from('plants').delete().eq('id', id);
      return true;
    } on PostgrestException catch (e) {
      log(e.message);
      return false;
    }
  }
}
