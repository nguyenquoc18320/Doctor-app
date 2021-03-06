import 'package:doctor_app/models/appointment.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/api_appointment.dart' as appointment_API;
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/doctor.dart' as doctor_API;
import 'package:intl/intl.dart';

import '../../models/user.dart';

class MyAppointmentController extends GetxController {
  var appointmentList = <Appointment>[].obs;

  var isUpcomming = true.obs;
  var past = false.obs;
  var canceled = false.obs;

  var selectedDay = DateTime.now().obs;

  var doctorList = <User>[].obs;

  var doneProcessStatus = false.obs;

  List<String> doctorIds = []; //list doctor id getted

  //get up comming appointments
  getUpcommingAppointments(String userid, int page) async {
    doneProcessStatus.value = false;
    List<Appointment> tem_appointments =
        await appointment_API.getUserUpcommingAppointments(
            globals.user?.id ?? '', page, selectedDay.value);

    //get doctor
    doctorIds = [];
    doctorList = <User>[].obs;

    for (int i = 0; i < tem_appointments.length; i++) {
      String id = tem_appointments[i].doctorId;
      //check whether doctor list contains item or not
      if (doctorIds.contains(id) == false) {
        User doctor = await doctor_API.getUserById(id);

        if (doctor.id!.isNotEmpty) {
          doctorList.value.add(doctor);
          doctorIds.add(id);
        }
      }
    }

    appointmentList.value = tem_appointments;
    isUpcomming.value = true;
    past.value = canceled.value = false;

    doneProcessStatus.value = true;
  }

  gePastAppointments(String userid, int page) async {
    doneProcessStatus.value = false;
    doctorIds = [];
    doctorList = <User>[].obs;

    List<Appointment> tem_appointments = await appointment_API
        .getUserPastAppointments(globals.user?.id ?? '', page);

    //get doctor
    doctorIds = [];
    doctorList = <User>[].obs;

    for (int i = 0; i < tem_appointments.length; i++) {
      String id = tem_appointments[i].doctorId;
      //check whether doctor list contains item or not
      if (doctorIds.contains(id) == false) {
        User doctor = await doctor_API.getUserById(id);

        if (doctor.id!.isNotEmpty) {
          doctorList.value.add(doctor);
          doctorIds.add(id);
        }
      }
    }

    appointmentList.value = tem_appointments;

    past.value = true;
    isUpcomming.value = canceled.value = false;

    doneProcessStatus.value = true;
    print('#' + appointmentList.length.toString());
  }

  getCancleAppointments(String userid, int page) async {
    doneProcessStatus.value = false;
    doctorIds = [];
    doctorList = <User>[].obs;

    List<Appointment> tem_appointments = await appointment_API
        .getUserCancelAppointments(globals.user?.id ?? '', page);

    //get doctor
    doctorIds = [];
    doctorList = <User>[].obs;

    for (int i = 0; i < tem_appointments.length; i++) {
      String id = tem_appointments[i].doctorId;
      //check whether doctor list contains item or not
      if (doctorIds.contains(id) == false) {
        User doctor = await doctor_API.getUserById(id);

        if (doctor.id!.isNotEmpty) {
          doctorList.value.add(doctor);
          doctorIds.add(id);
        }
      }
    }

    appointmentList.value = tem_appointments;

    canceled.value = true;
    isUpcomming.value = past.value = false;

    doneProcessStatus.value = true;
  }

  //change date for appointments
  changDate(String userid, int page, DateTime date) async {
    selectedDay.value = date;
    if (isUpcomming.value) {
      getUpcommingAppointments(userid, page);
    } else {
      // gePastAppointments(userid, page);
    }
  }
}
