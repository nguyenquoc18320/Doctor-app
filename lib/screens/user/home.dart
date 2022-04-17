import 'package:doctor_app/models/specialist.dart';
// import 'package:doctor_app/screens/doctor_list_custom.dart';
import 'package:doctor_app/screens/user/doctor_list.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/globals.dart' as globals;
import 'package:doctor_app/api/doctor.dart' as Doctor_API;
import '../../models/user.dart';
import 'package:doctor_app/widgets/user/bottomNavigationBar.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: globals.user!.avataId != null
                      ? Image.network(
                          globals.url + "/assets/" + globals.user!.avataId!,
                          headers: {"authorization": "Bearer " + globals.token},
                          height: 50,
                        )
                      : Image.asset(
                          'assets/logo/small_logo.png',
                          width: 50,
                          height: 50,
                        )),
            ),
            Text(
              'Hi, ' + globals.user!.firstName + ' ' + globals.user!.lastName,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _searchWidget(),
            SizedBox(height: 20),
            _specialistDoctorWidget(context),
            SizedBox(height: 10),
            _DoctorListWiget()
          ],
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
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              // borderSide: const BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
            hintText: 'Search',
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            )),
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  /*
  specialist doctor
  */
  Widget _specialistDoctorWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Specialist Doctor",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: 150,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Specialist.getSpecialist().length,
                    itemBuilder: (BuildContext context, int index) {
                      return _specialistItem(Specialist.getSpecialist()[index]);
                    })),
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
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: specialist.color),
          width: 100,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              specialist.icon,
              color: Colors.white,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              specialist.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
          ]),
        ),
      ),
    );
  }
}

//get list doctor
Future<List<User>> getDoctorList() async {
  return await Doctor_API.getDoctorList(10);
}

class _DoctorListWiget extends StatefulWidget {
  // const _DoctorListWiget({ Key? key }) : super(key: key);

  @override
  State<_DoctorListWiget> createState() => _DoctorListWigetState();
}

class _DoctorListWigetState extends State<_DoctorListWiget> {
//get doctor list
  Future<List<User>>? _doctorList;

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
                    "Doctors",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  child: Text(
                    'See all',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: 200,
                child: FutureBuilder<List<User>>(
                    future: _doctorList,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<User>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
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
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey)),
            width: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                user.avataId!.isNotEmpty
                    ? Image.network(
                        globals.url + "/assets/" + user.avataId!,
                        headers: {"authorization": "Bearer " + globals.token},
                        height: 100,
                        fit: BoxFit.fitWidth,
                      )
                    : Image.asset(
                        'assets/logo/small_logo.png',
                        height: 100,
                        fit: BoxFit.fitWidth,
                      ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  user.firstName + ' ' + user.lastName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.title ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )),
      ),
    );
  }
}
