import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verdhale/src/screens/vaccination/location_screen.dart';

import '../../components/bottom_navigation_bar/flow_bottom_navigation_bar.dart';
import '../../components/button/auth_button.dart';
import '../../components/calendar.dart';
import '../../models/time_model.dart';
import '../../utils/constant.dart';

class VaccinationAppointmentScreen extends StatefulWidget {
  const VaccinationAppointmentScreen({
    Key? key,
    required this.vaccination,
  }) : super(key: key);

  final String vaccination;
  @override
  _VaccinationAppointmentScreenState createState() =>
      _VaccinationAppointmentScreenState();
}

class _VaccinationAppointmentScreenState
    extends State<VaccinationAppointmentScreen> {
  DateTime selectedDay = DateTime.now();

  String dropdownTime = TimeModel.time[0];

  String aId = "AIPPXX${Random().nextInt(29932)}";

  void handleData(date) {
    setState(() {
      selectedDay = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomAppBar(),
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: SizedBox(
              height: 300,
              child: CustomCalendar(
                onDateSelected: (date) {
                  return handleData(date);
                },
              ),
            ),
          ),
          Center(
            child: _buildSubTitle(text: "Time"),
          ),
          _dropdownFilter()
        ],
      ),
    );
  }

  _dropdownFilter() {
    return Container(
      margin: const EdgeInsets.only(
        top: 15,
        right: 30,
        left: 30,
        bottom: 25,
      ),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: kRedColor,
          width: 2,
        ),
      ),
      child: Center(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          items: TimeModel.time
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownTime = newValue!;
            });
          },
          value: dropdownTime,
        ),
      ),
    );
  }

  buildBottomAppBar() {
    return FlowBottomNavigationBar(
      child: AuthButton(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const LocationScreen();
              },
            ),
          );
        },
        buttonName: "Proceed",
      ),
    );
  }

  _buildSubTitle({required String text}) {
    return Text(
      text,
      style: kAuthSubtitleTextStyle.copyWith(
        fontSize: 17,
        color: kRedColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        color: kGreenColor,
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Vaccination Appointment",
        style: kAppBarTextStyle,
      ),
    );
  }
}
