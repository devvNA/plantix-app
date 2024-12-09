import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_dropdown.dart';
import 'package:plantix_app/app/data/models/event_model.dart';
import 'package:plantix_app/app/modules/calendar/calendar_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends GetView<CalendarController> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Tanam'),
        elevation: 0,
      ),
      body: GetBuilder<CalendarController>(builder: (_) {
        return Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Obx(() => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: controller.focusedDay.value,
                      selectedDayPredicate: (day) =>
                          isSameDay(controller.selectedDay.value, day),
                      eventLoader: controller.getEventsForDay,
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: Colors.indigo,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        controller.selectedDay.value = selectedDay;
                        controller.focusedDay.value = focusedDay;
                      },
                    ),
                  )),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final selectedEvents =
                    controller.getEventsForDay(controller.selectedDay.value);
                return selectedEvents.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/icon/jadwal-tanam-empty.svg",
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 24.0),
                          Text('Tidak ada jadwal untuk hari ini',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: selectedEvents.length,
                        itemBuilder: (context, index) {
                          return EventCard(event: selectedEvents[index]);
                        },
                      );
              }),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.fieldList.clear();
          await controller.getLahan();
          if (context.mounted) {
            _tambahEventTanam(context);
          }
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
    );
  }

  void _tambahEventTanam(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Jadwal Tanam'),
        content: EventFormulir(),
      ),
    );
  }
}

class EventFormulir extends GetView<CalendarController> {
  const EventFormulir({super.key});

  Future<void> _selectDate(BuildContext context, bool isMulai) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != controller.tanggalMulai && isMulai) {
      controller.tanggalMulai = picked;
    } else if (picked != null &&
        picked != controller.tanggalPanen &&
        !isMulai) {
      controller.tanggalPanen = picked;
    }
    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: GetBuilder<CalendarController>(builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomDropDownSimple(
              label: "Nama Lahan",
              items: controller.fieldList.map((field) {
                return DropdownMenuItem<String>(
                  onTap: () {
                    controller.namaLahanController.text = field.fieldName;
                  },
                  value: field.fieldName,
                  child: Text(
                    field.fieldName,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              controller: controller.namaLahanController,
              onChanged: (value) {
                controller.namaLahanController.text = value ?? "";
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lahan tidak boleh kosong';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Tanggal Mulai :',
                    style: TStyle.bodyText2,
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(
                    controller.tanggalMulai != null
                        ? DateFormat('dd-MM-yyyy').format(
                            controller.tanggalMulai!,
                          )
                        : "Pilih Tanggal",
                    style: TStyle.bodyText2.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tanggal Panen :',
                    style: TStyle.bodyText2,
                  ),
                ),
                TextButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(
                    controller.tanggalPanen != null
                        ? DateFormat('dd-MM-yyyy').format(
                            controller.tanggalPanen!,
                          )
                        : "Pilih Tanggal",
                    style: TStyle.bodyText2.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  final newEvent = Event(
                    judul: controller.namaLahanController.text,
                    tanggalMulai: controller.tanggalMulai!,
                    tanggalPanen: controller.tanggalPanen!,
                    lokasi: controller.lokasiController.text,
                  );

                  controller.addEvent(newEvent);
                  Get.back();
                } else {
                  context.showSnackBar(
                      'Harap lengkapi semua field dan pilih tanggal.',
                      isError: true);
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      }),
    );
  }
}

class EventCard extends GetView<CalendarController> {
  final Event event;

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
                  event.judul,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Get.find<CalendarController>().removeEvent(event);
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(event.lokasi),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildDateInfo(
                  'Mulai',
                  DateFormat('dd MMM yyyy').format(event.tanggalMulai),
                  Colors.green,
                ),
                SizedBox(width: 16),
                _buildDateInfo(
                  'Panen',
                  DateFormat('dd MMM yyyy').format(event.tanggalPanen),
                  Colors.orange,
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
          color: color.withOpacity(0.1),
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
