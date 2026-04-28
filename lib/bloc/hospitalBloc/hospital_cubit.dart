import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:paw_pal_mobile/model/hospital_model.dart';
import 'package:paw_pal_mobile/routes/routes.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/CommonMethods.dart';

part 'hospital_state.dart';

class HospitalCubit extends Cubit<HospitalState> {
  FirebaseService service;

  HospitalCubit(this.service) : super(HospitalInitial());

  HospitalModel? model;

  List<HospitalModel> lstHospital = [];
  List<HospitalModel> filteredHospital = [];
  Future<void> getHospitals() async {
    emit(lstHospital.isEmpty ? HospitalLoading() : HospitalRefresh());
    try {
      lstHospital = await service.getHospitals();
      filteredHospital = lstHospital;
      emit(HospitalSuccess());
    } catch (e) {
      emit(HospitalError(e.toString()));
    }
  }

  bool isOpenNow(HospitalModel model) {
    DateTime now = DateTime.now();
    List<String> days = CommonMethods.getDaysList();
    String today = days[now.weekday % 7];
    int index = model.availability.indexWhere((e) => e.day == today);
    if (index == -1) return false;
    final todayData = model.availability[index];
    if (todayData.isOpen != true) return false;
    if (todayData.startTime == null || todayData.endTime == null) return false;
    TimeOfDay start = _convertToTime(todayData.startTime ?? "");
    TimeOfDay end = _convertToTime(todayData.endTime ?? "");

    TimeOfDay current = TimeOfDay.fromDateTime(now);

    int startMinutes = start.hour * 60 + start.minute;
    int endMinutes = end.hour * 60 + end.minute;
    int currentMinutes = current.hour * 60 + current.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  TimeOfDay _convertToTime(String time) {
    final format = time.replaceAll(" ", "");
    final period = format.substring(format.length - 2);
    final parts = format.substring(0, format.length - 2).split(":");

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    if (period == "PM" && hour != 12) hour += 12;
    if (period == "AM" && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  void navigateToDetailPage(HospitalModel model, BuildContext context) {
    this.model = model;
    context.pushNamed(Routes.vetCareDetailScreen);
    emit(HospitalSuccess());
  }

  AvailabilityModel? getTodayAvailability(HospitalModel model) {
    DateTime now = DateTime.now();

    List<String> days = CommonMethods.getDaysList();

    String today = days[now.weekday % 7];

    try {
      return model.availability.firstWhere((e) => e.day == today);
    } catch (e) {
      return null;
    }
  }

  Future<void> shareHospital() async {
    final model = this.model;
    if (model == null) return;

    String specializations = model.specializations.join(", ");

    String workingHours = model.availability
        .map((e) {
      if (e.isOpen == false) {
        return "${e.day}:-  Closed";
      }
      return "${e.day}:-  ${e.startTime} - ${e.endTime}";
    })
        .join("\n");

    String text =
        "${model.hospitalName}\n\n"
        "Specializations: $specializations\n\n"
        "Working Hours:\n$workingHours\n\n"
        "Contact: ${model.contactNumber}";

    List<XFile> files = [];

    if (model.imageUrl.isNotEmpty) {
      final response = await http.get(Uri.parse(model.imageUrl));

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/hospital.jpg');

      await file.writeAsBytes(response.bodyBytes);

      files.add(XFile(file.path));
    }

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        files: files,
      ),
    );
  }

  void searchHospital(String query) {
    if (query.isEmpty) {
      filteredHospital = lstHospital;
    } else {
      filteredHospital = lstHospital.where((hospital) {
        final name = hospital.hospitalName.toLowerCase();
        final address = hospital.address.toLowerCase();
        final search = query.toLowerCase();

        return name.contains(search) || address.contains(search);
      }).toList();
    }

    emit(HospitalSuccess());
  }
}
