import 'package:flutter/material.dart';

class PlantingEvent {
  final String title;
  final String fieldName;
  final DateTime date;
  final List<Event> events;

  PlantingEvent({
    required this.title,
    required this.fieldName,
    required this.date,
    required this.events,
  });
}

// Tambahkan kelas Event
class Event {
  final String eventTitle;
  final Color color;

  Event(
    this.eventTitle,
    this.color,
  );
}
