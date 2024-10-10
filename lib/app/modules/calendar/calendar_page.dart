import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantix_app/app/core/extensions/date_time_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_page_header.dart';
import 'package:plantix_app/app/data/models/event_model.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_controller.dart';

class CalendarPage extends GetView<CalendarController> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          PageHeader(
            title: 'Kalender',
            height: MediaQuery.of(context).size.height * 0.17,
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              buildCalendar(controller),
              Container(
                height: 8,
                width: double.infinity,
                color: Colors.grey.shade200,
              ),
              Expanded(child: _buildEventList()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    if (controller.events.isNotEmpty) {
      return ListView.builder(
        itemCount: controller.events.length,
        itemBuilder: (context, index) {
          final event = controller.events.elementAt(index);
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jadwal Tanam",
                    style: TStyle.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    event.date.toFormattedDatetime(),
                    style: TStyle.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(32),
                    onTap: () {
                      _showDetailDialog(
                          context, controller.events.elementAt(index));
                    },
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        // event.title,
                        // event.events.first.eventTitle,
                        event.events.map((e) => e.eventTitle).join(', '),
                        // 'Tanam + Pupuk Dasar + Perlakuan Benih',
                        style: TStyle.bodyText2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return SizedBox.shrink();
  }
}

Widget buildCalendar(CalendarController controller) {
  return Obx(() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      child: TableCalendar(
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          titleTextFormatter: (date, locale) => date.toFormattedDatetime(),
        ),
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: controller.selectedDate.value ?? DateTime.now(),
        selectedDayPredicate: (day) {
          return isSameDay(controller.selectedDate.value, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(controller.selectedDate.value, selectedDay)) {
            controller.updateSelectedDate(selectedDay);
          }
        },
        eventLoader: (day) {
          return controller.getEventsForDay(day).events;
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isEmpty) return SizedBox();
            return Positioned(
              bottom: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events.map((event) {
                  return Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 0.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (event as Event).color,
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  });
}

void _showDetailDialog(BuildContext context, PlantingEvent event) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Detail Aktivitas',
          style: TStyle.head3,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Jadwal Tanam',
                style: TStyle.bodyText1.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Tanggal: ${event.date.toFormattedDatetime()}',
                style: TStyle.bodyText2,
              ),
              const SizedBox(height: 16),
              Text(
                'Aktivitas: ${event.title}',
                style: TStyle.bodyText1.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                event.events.map((e) => e.eventTitle).join(',\n'),
                // '1. Tanam\n2. Pupuk Dasar\n3. Perlakuan Benih',
                style: TStyle.bodyText2,
              ),
              const SizedBox(height: 16),
              Text(
                'Kebutuhan Pupuk:',
                style: TStyle.bodyText1.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '- Urea: 50 kg/ha\n- SP-36: 75 kg/ha\n- KCl: 50 kg/ha',
                style: TStyle.bodyText2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Tutup',
              style: TStyle.bodyText1.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      );
    },
  );
}
