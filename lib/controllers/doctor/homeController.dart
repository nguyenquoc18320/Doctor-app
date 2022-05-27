import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/user.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/api_appointment.dart' as appointment_API;
import 'package:doctor_app/api/userAPI.dart' as user_API;
import 'package:doctor_app/globals.dart' as globals;

class HomeController extends GetxController {
  var upcommingAppointments = <Appointment>[].obs;

  var pendingAppointments = <Appointment>[].obs;

  var patientsForUpcoming = <User>[].obs;

  var patientsForPending = <User>[].obs;

  start() async {
    //get upcoming appointmetn in today
    List<Appointment> appointments =
        await appointment_API.getDoctorAcceptedUpcommingAppointmentsForDay(
            globals.user!.id ?? '', DateTime.now());

    //get user corresponding appointments
    int i = 0;
    while (i < appointments.length) {
      User? user = await user_API.getUserById(appointments[i].userCreated);

      if (user == null) {
        //no get user -> remove appointment
        appointments.removeAt(i);
      } else {
        patientsForUpcoming.value.add(user);
        i += 1;
      }
    }

    //get pending appointmetn from today
    List<Appointment> tempPendingappointments = await appointment_API
        .getpendinggAppointmentsFromday(globals.user!.id ?? '', DateTime.now());

    print('##' + tempPendingappointments.length.toString());
    //get user corresponding appointments
    i = 0;
    while (i < tempPendingappointments.length) {
      User? user =
          await user_API.getUserById(tempPendingappointments[i].userCreated);

      if (user == null) {
        //no get user -> remove appointment
        tempPendingappointments.removeAt(i);
      } else {
        patientsForPending.value.add(user);
        i += 1;
      }
    }

    upcommingAppointments.value = appointments;
    pendingAppointments.value = tempPendingappointments;
    print('###' + pendingAppointments.length.toString());
  }
}
