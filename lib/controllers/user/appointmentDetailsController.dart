import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/user.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/doctor.dart' as DoctorAPI;
import 'package:doctor_app/api/api_appointment.dart' as appointment_API;

class AppointmentDetailsController extends GetxController {
  Rx<User?> doctor = (null as User?).obs;

  Rx<Appointment?> appointment = (null as Appointment?).obs;

  Rx<bool> infoCancel = true.obs;

  //get appointment and doctor
  start(int appointmentid) async {
    //get appointment
    appointment.value = await appointment_API.getAppointmentById(appointmentid);
    if (appointment.value != null) {
      getDoctor(appointment.value!.doctorId);
    }
  }

  getDoctor(String id) async {
    //get doctor info
    User user = await DoctorAPI.getUserById(id);

    doctor.value = user;
  }

  cancelAppointment() async {
    if (appointment.value != null) {
      infoCancel.value =
          await appointment_API.cancelAppointment(appointment.value!.id!);

      if (infoCancel.value == true) {
        start(appointment.value!.id!);
      }
    }
  }
}
