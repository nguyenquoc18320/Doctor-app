import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/user.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/doctor.dart' as DoctorAPI;
import 'package:doctor_app/api/api_appointment.dart' as appointment_API;

class RatingController extends GetxController {
  Rx<User?> doctor = (null as User?).obs;

  Rx<Appointment?> appointment = (null as Appointment?).obs;

  Rx<bool> infoCancel = true.obs;

  var errorMessage = ''.obs;

  var doneProcessStatus = false.obs;

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

  rating(int num_stars, String comment) async {
    errorMessage.value = '';
    doneProcessStatus.value = false;

    if (appointment != null) {
      bool result = await appointment_API.rating(
          appointment.value!.id!, num_stars, comment);

      await start(appointment.value!.id!);
      errorMessage.value = 'Sucessfully';
    } else {
      errorMessage.value = 'Error! Please try again';
    }

    doneProcessStatus.value = true;
  }
}
