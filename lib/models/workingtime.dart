import 'package:intl/intl.dart';

class WorkingTime {
  int id;
  String userCreated;
  String day;
  DateTime startTime;
  DateTime endTime;

  WorkingTime(
      {required this.id,
      required this.userCreated,
      required this.day,
      required this.startTime,
      required this.endTime});

  factory WorkingTime.fromJson(Map<String, dynamic> json) {
    return WorkingTime(
        id: json['id'],
        userCreated: json['user_created'] ?? '',
        day: json['day'],
        startTime: DateFormat('hh:mm:ss').parse(json['time_from']),
        endTime: DateFormat('hh:mm:ss').parse(json['time_to']));
  }

  // DateTime convertDay(String day) {
  //   List<String> days = ['mon', 'tue', 'wes', 'thu', 'fri', 'sat', 'sun'];
  //   List<DateTime> convertedDays = [DateTime.monday, DateTime.]

  // }
}
