import 'package:doctor_app/models/specialist.dart';
import 'package:doctor_app/screens/user/doctor_info.dart';
import 'package:flutter/material.dart';
import 'package:doctor_app/api/doctor.dart' as Doctor_API;
import 'package:flutter/rendering.dart';
import 'package:doctor_app/globals.dart' as globals;

import '../../models/user.dart';

class DoctorListWidget extends StatefulWidget {
  Specialist? specialist;

  DoctorListWidget({this.specialist});

  @override
  State<DoctorListWidget> createState() => _DoctorListWidgetState();
}

class _DoctorListWidgetState extends State<DoctorListWidget> {
  Future<List<User>>? doctorList;

  TextEditingController searchTextController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    doctorList = getDoctorList(widget.specialist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _searchWidget(context),
        SizedBox(height: 10),
        _typesOfSpecialist(context),
        SizedBox(height: 10),
        _doctorListWidget(context)
      ]),
    );
  }

  //searching widget
  Widget _searchWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          Container(
            width: 320,
            child: TextField(
              controller: searchTextController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchText = searchTextController.text;
                      doctorList = getDoctorList(widget.specialist);
                      setState(() {});
                    },
                    icon: Icon(Icons.search),
                  )),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  //type of specialists
  Widget _typesOfSpecialist(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: false,
        itemCount: Specialist.getSpecialist().length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0
              ? _typeAllForSpecialist()
              : _eachTypeOfSpecialist(
                  context, Specialist.getSpecialist()[index - 1]);
        },
      ),
    );
  }

  //all specialists
  Widget _typeAllForSpecialist() {
    bool selected = (widget.specialist == null);

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.specialist = null;
          doctorList = getDoctorList(widget.specialist);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: selected
                ? Color.fromARGB(255, 10, 119, 244)
                : Colors.transparent,
            border:
                Border.all(color: Color.fromARGB(255, 10, 119, 244), width: 3)),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'All',
          style: TextStyle(
              fontSize: 16,
              color:
                  selected ? Colors.white : Color.fromARGB(255, 10, 119, 244),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //each type of specialists
  Widget _eachTypeOfSpecialist(BuildContext context, Specialist specialist) {
    bool selected = false;
    if (widget.specialist != null)
      selected = (specialist.name == widget.specialist!.name);

    return GestureDetector(
      onTap: () {
        widget.specialist = specialist;
        doctorList = getDoctorList(widget.specialist);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: selected
                ? Color.fromARGB(255, 10, 119, 244)
                : Colors.transparent,
            border:
                Border.all(color: Color.fromARGB(255, 10, 119, 244), width: 3)),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          specialist.name.split(' Specialist')[0],
          style: TextStyle(
              fontSize: 16,
              color:
                  selected ? Colors.white : Color.fromARGB(255, 10, 119, 244),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//doctor list
  Widget _doctorListWidget(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<User>>(
          future: doctorList,
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                print('Length: ' + snapshot.data!.length.toString());
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _doctorItemWidget(
                            context, snapshot.data![index]);
                      }),
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }),
    );
  }

  //widget for each doctor
  Widget _doctorItemWidget(BuildContext context, User user) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoctorInfoScreen(user.id ?? '')),
        )
      },
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey)),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: user.avataId!.isNotEmpty
                    ? Image.network(
                        globals.url + "/assets/" + user.avataId!,
                        headers: {"authorization": "Bearer " + globals.token},
                        height: 100,
                      )
                    : Image.asset('assets/logo/small_logo.png'),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.firstName + ' ' + user.lastName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.title ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    user.location,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              )
            ]),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  /* 
get doctor list 
*/
  Future<List<User>> getDoctorList(Specialist? specialist) async {
    if (specialist != null) {
      if (searchTextController.text.isEmpty)
        return await Doctor_API.getDoctorsBySpecialist(specialist);
      else {
        return await Doctor_API.getDoctorsBySpecialist(
            specialist, searchTextController.text);
      }
    } else {
      return await Doctor_API.getDoctorList(10);
    }
  }
}
