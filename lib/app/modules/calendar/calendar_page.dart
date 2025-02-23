import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plantix_app/app/core/extensions/snackbar_ext.dart';
import 'package:plantix_app/app/core/theme/app_color.dart';
import 'package:plantix_app/app/core/theme/typography.dart';
import 'package:plantix_app/app/core/widgets/custom_dropdown.dart';
import 'package:plantix_app/app/core/widgets/custom_loading.dart';
import 'package:plantix_app/app/core/widgets/custom_text_form.dart';
import 'package:plantix_app/app/modules/calendar/calendar_controller.dart';
import 'package:plantix_app/app/modules/calendar/widgets/card_event_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends GetView<CalendarController> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Tanam'),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: "Refresh",
            splashRadius: 25,
            onPressed: () {
              controller.onRefresh();
            },
            icon: const Icon(
              Icons.refresh,
              size: 24.0,
            ),
          ),
        ],
      ),
      body: GetBuilder<CalendarController>(builder: (_) {
        return Stack(
          children: [
            Column(
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
                              color: AppColors.primary.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: BoxDecoration(
                              color: Colors.indigo[600],
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
                    final selectedEvents = controller
                        .getEventsForDay(controller.selectedDay.value);
                    return selectedEvents.isEmpty
                        ? Center(
                            child: SingleChildScrollView(
                              child: Column(
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
                              ),
                            ),
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
            ),
            if (controller.isLoading.value) const LoadingWidgetBG(),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.fieldList.clear();
          await controller.getLahan();
          if (context.mounted) {
            controller.tanggal = null;
            controller.alamatController.clear();
            controller.notesController.clear();
            controller.namaLahanController.clear();
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
            const SizedBox(height: 12.0),
            CustomTextFormSimple(
              label: "Catatan",
              controller: controller.notesController,
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tanggal :',
                  style: TStyle.bodyText2,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      controller.tanggal != null
                          ? DateFormat('dd-MM-yyyy').format(controller.tanggal!)
                          : "Pilih Tanggal",
                      style:
                          TStyle.bodyText2.copyWith(color: AppColors.primary),
                    ),
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
                if (controller.formKey.currentState!.validate() &&
                    controller.tanggal != null) {
                  controller.createEvent();
                  Get.back();
                } else {
                  context.showSnackBar(
                      'Harap lengkapi semua field dan pilih tanggal.',
                      isError: true);
                }
                controller.tanggal = null;
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      }),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.tanggal ?? DateTime.now(),
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
    if (picked != null && picked != controller.tanggal) {
      controller.tanggal = picked;
      controller.update();
    }
  }
}
