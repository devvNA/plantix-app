import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:plantix_app/app/core/exceptions/exceptions.dart';
import 'package:plantix_app/app/data/models/event_model.dart';
import 'package:plantix_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarRepository {
  final userId = supabase.auth.currentSession!.user.id;

  Future<Either<Failure, List<EventModel>>> getMyEvents() async {
    try {
      final response = await supabase
          .from('planting_schedules')
          .select()
          .eq('user_id', userId);

      final events = response.map((e) => EventModel.fromJson(e)).toList();

      log(response.toString());
      return right(events);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<Either<Failure, EventModel>> createEvent({
    required String fieldName,
    required String notes,
    required String address,
    required String eventDate,
  }) async {
    try {
      final userId = supabase.auth.currentSession!.user.id;
      final query = {
        "title": fieldName,
        "notes": notes,
        "created_at": DateTime.now().toIso8601String(),
        "updated_at": DateTime.now().toIso8601String(),
        "address": address,
        "user_id": userId,
        "event_date": eventDate,
      };

      final response =
          await supabase
              .from('planting_schedules')
              .insert(query)
              .select()
              .single();

      final event = EventModel.fromJson(response);
      return right(event);
    } on PostgrestException catch (e) {
      log(e.message);
      return left(Exception(e.message));
    } catch (e) {
      log(e.toString());
      return left(Exception(e.toString()));
    }
  }

  Future<bool> deleteEvent(int id) async {
    try {
      await supabase.from('planting_schedules').delete().eq('id', id);
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
