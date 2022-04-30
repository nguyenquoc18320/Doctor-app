import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/user.dart';
import 'package:doctor_app/models/workingtime.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/doctor.dart' as DoctorAPI;
import 'package:doctor_app/api/api_workingtime.dart' as WorkingTimeAPI;
import 'package:doctor_app/api/api_appointment.dart' as appointmentAPI;
import 'package:intl/intl.dart';

class DoctorInfoController extends GetxController {
  var doctor = User(
          id: '',
          firstName: '',
          lastName: '',
          email: '',
          gender: '',
          location: '',
          birthdate: null,
          avataId: '',
          description: '')
      .obs;

  var workingTime = <WorkingTime>[].obs;

  var daysForAppointments = <DateTime>[].obs;

  var bookAppointment = false.obs;

  var timesForAppointment = <DateTime>[].obs;

  List<String> listFormatDate = [
    'mon',
    'tue',
    'web',
    'thu',
    'fri',
    'sat',
    'sun'
  ];

  start() {
    timesForAppointment.value = [];
  }

  getDoctor(String id, DateTime? selectedAppointment) async {
    //get doctor info
    User user = await DoctorAPI.getUserById(id);

    doctor.value = user;

    if (doctor.value.id!.isNotEmpty) {
      //get doctor's working-time
      List<WorkingTime> workingTimes =
          await WorkingTimeAPI.getWorkingTimeByDoctorID(id);

      workingTime.value = workingTimes;

      getDaysForAppointments();
    }
  }

  /*
  Create list date for appointment,
  for next 7 days from now
  */
  getDaysForAppointments() {
    List<DateTime> days = [];

    for (int i = 0; i <= 6; i++) {
      DateTime day = DateTime.now().add(Duration(days: i));

      WorkingTime? dayworking = isWorkingDay(day);
      if (dayworking != null) {
        day = DateTime(day.year, day.month, day.day, dayworking.startTime.hour,
            dayworking.startTime.minute);
        days.add(day);
      }
    }

    daysForAppointments.value = days;
  }

  WorkingTime? isWorkingDay(DateTime day) {
    for (var time in workingTime) {
      if (DateFormat('EEEE').format(day).toLowerCase().substring(0, 3) ==
          time.day) {
        return time;
      }
    }
    return null;
  }

  /*get time for each working day*/
  getTimeForEachWorkingDay(DateTime? day) async {
    timesForAppointment.value = [];

    if (day != null) {
      //get all appointment of doctor
      List<Appointment> bookedAppoinments = await appointmentAPI
          .getAppointmentsOfDoctorInDay(doctor.value.id!, day);

      //get day for appointment
      WorkingTime? wtime = isWorkingDay(day);

      if (wtime != null) {
        //get start time and end time
        DateTime startTime = DateTime(day.year, day.month, day.day,
            wtime.startTime.hour, wtime.startTime.minute);

        DateTime endTime = DateTime(day.year, day.month, day.day,
            wtime.endTime.hour, wtime.endTime.minute);

        DateTime time = startTime;

        while (time.isBefore(endTime)) {
          if (isBooked(bookedAppoinments, time) == false) {
            timesForAppointment.value.add(time);
          }
          time = time.add(Duration(minutes: 30));
        }
      }
    }
  }

  bool isBooked(List<Appointment> appointments, DateTime date) {
    for (Appointment a in appointments) {
      if (a.time.hour == date.hour && a.time.minute == date.minute) {
        return true;
      }
    }
    return false;
  }
}
