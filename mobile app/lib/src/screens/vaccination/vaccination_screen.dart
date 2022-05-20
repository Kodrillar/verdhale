import 'package:flutter/material.dart';
import 'package:verdhale/src/components/vaccination/vaccination_card.dart';
import 'package:verdhale/src/screens/vaccination/vaccination_appointment_screen.dart';
import 'package:verdhale/src/utils/constant.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/alert_dialog.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({Key? key}) : super(key: key);

  @override
  _VaccinationScreenState createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  void getLocation() async {
    try {
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
    } catch (_) {
      alertDialog(
        context: context,
        title: "Oops! something went wrong.",
        content: "Kindly enable location for better experience.",
      );
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: ListView(
          children: [
            VaccinationCard(
              title: "Covid 19",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VaccinationAppointmentScreen(
                      vaccination: "Covid 19",
                    ),
                  ),
                );
              },
            ),
            VaccinationCard(
              title: "Polio",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VaccinationAppointmentScreen(
                      vaccination: "Polio",
                    ),
                  ),
                );
              },
            ),
            VaccinationCard(
              title: "Tetanus",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VaccinationAppointmentScreen(
                      vaccination: "Tetanus",
                    ),
                  ),
                );
              },
            ),
            VaccinationCard(
              title: "Hepatitis B",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VaccinationAppointmentScreen(
                      vaccination: "Hepatitis B",
                    ),
                  ),
                );
              },
            )
          ],
        ));
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

      // ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Vaccination",
        style: kAppBarTextStyle,
      ),
    );
  }
}
