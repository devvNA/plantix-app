import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  const EventModel({
    required this.id,
    required this.title,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
    required this.userId,
    required this.eventDate,
  });

  final int id;
  final String title;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String address;
  final String userId;
  final DateTime? eventDate;

  EventModel copyWith({
    int? id,
    String? title,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? address,
    String? userId,
    DateTime? eventDate,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      eventDate: eventDate ?? this.eventDate,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      notes: json["notes"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      address: json["address"] ?? "",
      userId: json["user_id"] ?? "",
      eventDate: DateTime.tryParse(json["event_date"] ?? ""),
    );
  }

  @override
  String toString() {
    return "$id, $title, $notes, $createdAt, $updatedAt, $address, $userId, $eventDate, ";
  }

  @override
  List<Object?> get props => [
        id,
        title,
        notes,
        createdAt,
        updatedAt,
        address,
        userId,
        eventDate,
      ];
}
