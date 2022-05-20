import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/api/api_appointment.dart' as appointment_API;
import 'package:doctor_app/api/userAPI.dart' as user_API;
import 'package:doctor_app/models/user.dart';
import 'package:get/get.dart';

class AppointmentDetailController extends GetxController {
  Rx<Appointment?> appointment = (null as Appointment?).obs;
  Rx<User?> user = (null as User?).obs;

  var message = ''.obs;

  var doneProcess = false.obs;

  getAppointment(int appointmentId) async {
    //get appointment
    appointment.value = await appointment_API.getAppointmentById(appointmentId);
    if (appointment.value != null) {
      print('call');
      //get user
      user.value = await user_API.getUserById(appointment.value!.userCreated);
      // print(user.value == null);
    }
  }

  cancelAppointment() async {
    doneProcess.value = false;
    message.value = '';
    if (appointment.value != null) {
      bool info = await appointment_API
          .cancelAppointmentByDoctorRole(appointment.value!.id!);

      if (info == true) {
        getAppointment(appointment.value!.id!);
      } else {
        message.value = 'Cannot cancel the appointment! Please try again';
      }
    }
    doneProcess.value = true;
  }

  acceptAppointment() async {
    doneProcess.value = false;
    message.value = '';
    if (appointment.value != null) {
      bool info = await appointment_API
          .acceptedAppointmentByDoctorRole(appointment.value!.id!);

      if (info == true) {
        getAppointment(appointment.value!.id!);
      } else {
        message.value = 'Cannot accept the appointment. Please try again!';
      }
    }
    doneProcess.value = true;
  }

  doneAppointment(String result) async {
    doneProcess.value = false;
    message.value = '';
    if (appointment.value != null) {
      bool info = await appointment_API.donedAppointmentByDoctorRole(
          appointment.value!.id!, result);

      if (info == true) {
        getAppointment(appointment.value!.id!);
      } else {
        message.value = 'Cannot complete the appointment. Please try again!';
      }
    }
    doneProcess.value = true;
  }
}
