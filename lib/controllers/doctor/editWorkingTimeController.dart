import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/workingtime.dart';
import 'package:get/get.dart';
import 'package:doctor_app/api/api_workingtime.dart' as workingtime_API;
import 'package:doctor_app/api/api_appointment.dart' as appointment_API;
import 'package:doctor_app/globals.dart' as globals;
import 'package:intl/intl.dart';

class EditWorkingTimeController extends GetxController {
  var workingTimeList = <WorkingTime>[].obs;

  //status list for all times from Mon to Sun, day open or not
  var statusDays = <bool>[].obs;

  var errorMessage = ''.obs;
  //creat working time list for edit
  List<String> dayString = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  var doneProcessStatus = true.obs; //for loading data

  init() async {
    errorMessage.value = '';
    workingTimeList.value = [];
    //init status list
    statusDays.value = [];

    for (int i = 0; i < 7; i++) {
      statusDays.add(false);
    }

    //  ////get 7 next days (sorted by mon -> sun)
    // List<DateTime> sevenNextDays = [];
    // DateTime now = DateTime.now();

    // //init the list
    // for (int i = 0; i < 7; i++) {
    //   sevenNextDays.add(now);
    // }

    // for (int i = 0; i < 7; i++) {
    //   DateTime date = now.add(Duration(days: i));
    //   //get index of day
    //   int index = dayString.indexOf(
    //       DateFormat('EEEE').format(date).substring(0, 3).toLowerCase());
    //   sevenNextDays[index] = date;
    // }

    //get working times from api
    List<WorkingTime> tempWorking =
        await workingtime_API.getWorkingTimeByDoctorID(globals.user!.id ?? '');

    for (int i = 0; i < 7; i++) {
      String day = dayString[i];
      //set status
      WorkingTime? wk;

      for (WorkingTime w in tempWorking) {
        if (w.day == day) {
          wk = w;
          break;
        }
      }

      DateTime now = DateTime.now();

      //wktime in api
      if (wk != null) {
        statusDays[i] = true;
        workingTimeList.add(wk);
      } else {
        //if wk not in api, create working time instance with id=-1

        wk = WorkingTime(
            id: -1,
            userCreated: globals.user!.id!,
            day: day,
            startTime: new DateTime(now.year, now.month, now.day, 0, 0, 0),
            endTime: new DateTime(now.year, now.month, now.day, 0, 0, 0));
        workingTimeList.add(wk);
      }
    }
  }

  editWorkingTime() async {
    //validate start time and end time
    doneProcessStatus.value = false;
    errorMessage.value = '';

    //check time sessions are valid
    for (int i = 0; i < 7; i++) {
      if (statusDays.value[i]) {
        WorkingTime wk = workingTimeList.value[i];
        if (wk.startTime.add(Duration(minutes: 30)).isAfter(wk.endTime)) {
          doneProcessStatus.value = true;
          errorMessage.value = 'Error time, Please check time you setted!';
          return;
        }
      }
    }

    ////get 7 next days (sorted by mon -> sun)
    List<DateTime> sevenNextDays = [];
    DateTime now = DateTime.now();

    //init the list
    for (int i = 0; i < 7; i++) {
      sevenNextDays.add(now);
    }

    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      //get index of day
      int index = dayString.indexOf(
          DateFormat('EEEE').format(date).substring(0, 3).toLowerCase());
      sevenNextDays[index] = date;
    }

    //error day
    List<DateTime> errDays = [];
    for (int i = 0; i < 7; i++) {
      WorkingTime wk = workingTimeList.value[i];
      //
      DateTime startday = DateTime(
          sevenNextDays[i].year, sevenNextDays[i].month, sevenNextDays[i].day);
      DateTime endday = DateTime(sevenNextDays[i].year, sevenNextDays[i].month,
          sevenNextDays[i].day, 23, 59, 0);

      //check day is removed (status =fasle and wk.id = -1)
      if (statusDays.value[i] == false && wk.id != -1) {
        //get all appointments in day, if existing -> return error messs
        List<Appointment> apps = await appointment_API
            .getAppointmentsByDoctorInPeriodAndPendingOrAccepted(
                globals.user!.id ?? '', startday, endday);

        if (apps.isNotEmpty) {
          errDays.add(startday);
        }
      } else if (wk.id != -1) {
        //check to make sure no appointments outside of wk
        //before start wk
        List<Appointment> apps = await appointment_API
            .getAppointmentsByDoctorInPeriodAndPendingOrAccepted(
                globals.user!.id ?? '',
                startday,
                DateTime(startday.year, startday.month, startday.day,
                    wk.startTime.hour, wk.startTime.minute));

        if (apps.isNotEmpty) {
          errDays.add(startday);
        }

        //after end wk
        apps = await appointment_API
            .getAppointmentsByDoctorInPeriodAndPendingOrAccepted(
                globals.user!.id ?? '',
                DateTime(startday.year, startday.month, startday.day,
                    wk.endTime.hour, wk.endTime.minute - 1),
                endday);

        if (apps.isNotEmpty) {
          errDays.add(startday);
        }
      }
    }

    if (errDays.isNotEmpty) {
      String errday = '';
      for (DateTime d in errDays) {
        errday += DateFormat('dd-MMMM').format(d) + ', ';
      }

      doneProcessStatus.value = true;
      errorMessage.value =
          'On $errday having appointments! Please cancel them before edit working time.';
      return;
    }

    if (errorMessage.isEmpty) {
      //check all appointmets are in working time sessions
      for (int i = 0; i < 7; i++) {
        //create new working time (status = true, wk.id = -1)
        if (statusDays.value[i] == true && workingTimeList.value[i].id == -1) {
          WorkingTime? new_wk =
              await workingtime_API.createWorkingTime(workingTimeList.value[i]);

          if (new_wk == null) {
            errorMessage.value = "Error. Please try again!";
            break;
          }
        } else if (statusDays.value[i] == true &&
            workingTimeList.value[i].id != 1) {
          //update working time
          WorkingTime? update_wk =
              await workingtime_API.updateWorkingTime(workingTimeList.value[i]);

          if (update_wk == null) {
            errorMessage.value = "Error. Please try again!";
            break;
          }
        } else if (statusDays.value[i] == false &&
            workingTimeList.value[i].id != -1) {
          //delete wk
          bool delete_wk =
              await workingtime_API.deleteWorkingTime(workingTimeList.value[i]);

          if (delete_wk == false) {
            errorMessage.value = "Error. Please try again!";
            break;
          }
        }
      }
      errorMessage.value = 'Updated your working time';
      doneProcessStatus.value = true;
    }
  }
}
