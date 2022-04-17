import 'package:doctor_app/models/specialist.dart';
import 'package:doctor_app/models/user.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/doctor.dart' as Doctor_API;

class DoctorListController extends GetxController {
  List<User> doctorList = <User>[].obs();

  getDoctorList(Specialist? specialist, [String doctorName = '']) async {
    if (specialist != null) {
      if (doctorName.isEmpty)
        doctorList = await Doctor_API.getDoctorsBySpecialist(specialist);
      else {
        doctorList =
            await Doctor_API.getDoctorsBySpecialist(specialist, doctorName);
      }
    } else {
      doctorList = await Doctor_API.getDoctorList(10);
    }
  }
}
