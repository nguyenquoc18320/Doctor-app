import 'package:doctor_app/models/appointment.dart';
import 'package:doctor_app/models/specialist.dart';
import 'package:doctor_app/screens/user/detailAppointment.dart';
import 'package:doctor_app/screens/user/doctor_info.dart';
// import 'package:doctor_app/screens/doctor_list_custom.dart';
import 'package:doctor_app/screens/user/doctor_list.dart';
import 'package:doctor_app/screens/user/myAppointment.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/doctor.dart' as Doctor_API;
import 'package:intl/intl.dart';
import '../../models/user.dart';
import 'package:doctor_app/widgets/user/bottomNavigationBar.dart';
import 'package:doctor_app/api/api_appointment.dart' as Appointment_API;

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<List<Appointment>>? _upcommingAppointmentList;
  bool upcomming = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _upcommingAppointmentList = Appointment_API.getUserUpcommingAppointments(
        globals.user!.id!, 1, DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: globals.user!.avataId != null
                        ? Image.network(
                            globals.url + "/assets/" + globals.user!.avataId!,
                            headers: {
                              "authorization": "Bearer " + globals.token
                            },
                            height: 40,
                            width: 40,
                          )
                        : Image.asset(
                            'assets/logo/new_logo.png',
                            width: 40,
                            height: 40,
                          )),
              ),
              Column(
                children: [
                  Text('Welcom back,',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      )),
                  Text(
                    globals.user!.firstName + ' ' + globals.user!.lastName,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _searchWidget(),
              SizedBox(height: 16),
              upCommingAppointment(context),
              SizedBox(height: 24),
              _specialistDoctorWidget(context),
              SizedBox(height: 24),
              _DoctorListWiget(upcomming)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(currentIndex: 0),
    );
  }

/*
search
*/
  Widget _searchWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: TextField(
        decoration: InputDecoration(
            fillColor: Color.fromRGBO(243, 243, 243, 1),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(40.0),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            filled: true,
            border: OutlineInputBorder(
              // borderSide: const BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(40.0),
            ),
            hintText: 'Search for doctor',
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.black38,
            ),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            )),
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget upCommingAppointment(BuildContext context) {
    Future<User> doctor;

    return FutureBuilder<List<Appointment>>(
        future: _upcommingAppointmentList,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Appointment>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Appointment? appointment;

              //get appointmet with accepted status
              for (Appointment a in snapshot.data!) {
                if (a.status == 'accepted') {
                  appointment = a;
                  break;
                }
              }

              if (appointment != null) {
                doctor = Doctor_API.getUserById(appointment.doctorId);

                return FutureBuilder<User>(
                    future: doctor,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<User> snapshot_doctor,
                    ) {
                      if (snapshot_doctor.connectionState ==
                          ConnectionState.waiting) {
                        return SizedBox();
                      } else if (snapshot_doctor.connectionState ==
                          ConnectionState.done) {
                        if (snapshot_doctor.hasData) {
                          upcomming = true;
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(color: Color(0xFF2563EB)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Let's check you upcoming schedule!",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        /////////appointment
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailAppointmentScreen(
                                                      appointmentId:
                                                          appointment!.id,
                                                    )),
                                          );
                                        },
                                        child: Container(
                                          width: 213,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(children: [
                                            snapshot_doctor
                                                    .data!.avataId!.isNotEmpty
                                                ? ClipRRect(
                                                    child: Image.network(
                                                      globals.url +
                                                          "/assets/" +
                                                          snapshot_doctor
                                                              .data!.avataId!,
                                                      headers: {
                                                        "authorization":
                                                            "Bearer " +
                                                                globals.token
                                                      },
                                                      height: 56,
                                                      width: 56,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    child: Image.asset(
                                                      'assets/logo/small_logo.png',
                                                      height: 56,
                                                      width: 56,
                                                      fit: BoxFit.fitWidth,
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFFF003D),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Text(
                                                    DateFormat('MMMM dd, HH:mm')
                                                        .format(snapshot
                                                            .data![0].time),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  'Dr. ' +
                                                      snapshot_doctor
                                                          .data!.firstName +
                                                      ' ' +
                                                      snapshot_doctor
                                                          .data!.lastName,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ]),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    myAppointmentScreen()),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'More',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ]),
                          );
                        }
                      }
                      return SizedBox();
                    });
              }
            }
          }
          return SizedBox();
        });
  }

  /*
  specialist doctor
  */
  Widget _specialistDoctorWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Doctor by Specialists",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: 80,
                child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: Specialist.getSpecialist().length,
                      itemBuilder: (BuildContext context, int index) {
                        return _specialistItem(
                            Specialist.getSpecialist()[index]);
                      }),
                )),
          ],
        ),
      ),
    );
  }

  /*
  for each specialist
  */
  Widget _specialistItem(Specialist specialist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoctorListWidget(
                    specialist: specialist,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: specialist.color),
              child: Icon(
                specialist.icon,
                color: Colors.white,
              ),
            ),
            Text(
              specialist.name.split(' ')[0],
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
          ]),
        ),
      ),
    );
  }
}

//get upcomming appointment

//get list doctor
Future<List<User>> getDoctorList() async {
  return await Doctor_API.getDoctorList(10);
}

class _DoctorListWiget extends StatefulWidget {
  bool upcomming;

  _DoctorListWiget(this.upcomming);
  @override
  State<_DoctorListWiget> createState() => _DoctorListWigetState(upcomming);
}

class _DoctorListWigetState extends State<_DoctorListWiget> {
//get doctor list
  Future<List<User>>? _doctorList;
  bool upcomming;

  _DoctorListWigetState(this.upcomming);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _doctorList = getDoctorList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Popular Doctors",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorListWidget()),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'More',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF60A5FA),
                            fontWeight: FontWeight.w700),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Color(0xFF60A5FA),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: upcomming
                    ? MediaQuery.of(context).size.height * 0.25
                    : MediaQuery.of(context).size.height * 0.5,
                child: FutureBuilder<List<User>>(
                    future: _doctorList,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<User>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(child: CircularProgressIndicator()));
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _doctorItem(
                                    context, snapshot.data![index]);
                              });
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    })),
          ],
        ),
      ),
    );
  }

  Widget _doctorItem(BuildContext context, User user) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DoctorInfoScreen(user.id ?? '')));
      },
      child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return Container(
            padding: EdgeInsets.only(right: 10),
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                user.avataId!.isNotEmpty
                    ? ClipRRect(
                        child: Image.network(
                          globals.url + "/assets/" + user.avataId!,
                          headers: {"authorization": "Bearer " + globals.token},
                          height: 96,
                          width: 96,
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image.asset(
                          'assets/logo/small_logo.png',
                          height: 96,
                          width: 96,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                SizedBox(
                  width: 16,
                ),
                Container(
                  width: (constraints.maxWidth - 100) * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ' + user.firstName + ' ' + user.lastName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.title ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        user.location,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                )
              ],
            ));
      }),
    );
  }
}
