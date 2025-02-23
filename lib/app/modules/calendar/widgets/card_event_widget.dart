import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/data/models/event_model.dart';
import 'package:plantix_app/app/modules/calendar/calendar_controller.dart';

class EventCard extends GetView<CalendarController> {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.title,
                  style: TStyle.head3,
                ),
                IconButton(
                  splashRadius: 15,
                  constraints: BoxConstraints(),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: () {
                    controller.deleteEvent(event);
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 20, color: Colors.red),
                SizedBox(width: 4),
                Expanded(
                  child: Text(event.address),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildDateInfo(
                  'Tanggal',
                  event.eventDate!.toFormattedDateWithDay(),
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                _buildDateInfo(
                  'Deskripsi',
                  event.notes,
                  Colors.amber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, String date, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(date),
          ],
        ),
      ),
    );
  }
}
