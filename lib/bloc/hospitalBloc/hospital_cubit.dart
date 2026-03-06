import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:paw_pal_mobile/model/hospital_model.dart';
import 'package:paw_pal_mobile/services/firebase_auth_service.dart';

part 'hospital_state.dart';

class HospitalCubit extends Cubit<HospitalState> {
  FirebaseService service;

  HospitalCubit(this.service) : super(HospitalInitial());

  List<HospitalModel> lstHospital = [];

  Future<void> getHospitals() async {
    emit(lstHospital.isEmpty ? HospitalLoading() : HospitalRefresh());
    try {
      lstHospital = await service.getHospitals();
      emit(HospitalSuccess());
    } catch (e) {
      emit(HospitalError(e.toString()));
    }
  }

  bool isOpenNow(HospitalModel model) {
    DateTime now = DateTime.now();
    List<String> days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];
    String today = days[now.weekday % 7];
    int index = model.availability.indexWhere((e) => e.day == today);
    if (index == -1) return false;
    final todayData = model.availability[index];
    if (todayData.isOpen != true) return false;
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
}
