import 'dart:io';

import 'package:flutter/material.dart';
import 'package:verdhale/src/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:verdhale/src/components/carousel_slider.dart';
import 'package:verdhale/src/components/error/error_text.dart';
import 'package:verdhale/src/models/free_service_model.dart';
import 'package:verdhale/src/repository/auth/freeservice_repository.dart';
import 'package:verdhale/src/screens/ambulance_screen.dart';
import 'package:verdhale/src/screens/bloodbank_screen.dart';
import 'package:verdhale/src/screens/diagnostics_screen.dart';
import 'package:verdhale/src/screens/hospital_screen.dart';
import 'package:verdhale/src/screens/pharmacy_screen.dart';
import 'package:verdhale/src/screens/vaccination/vaccination_screen.dart';
import 'package:verdhale/src/utils/constant.dart';

import '../components/alert_dialog.dart';
import '../services/api.dart';
import '../utils/secure_storage.dart';

FreeserviceRepository _freeserviceRepository = FreeserviceRepository();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic freeServiceData;
  String? userName;
  Future<List<FreeServiceModel>> getFreeservices() async {
    try {
      freeServiceData = await _freeserviceRepository.getFreeservice(
        endpoint: endpoints["getFreeservice"],
      );
    } on SocketException {
      alertDialog(
        context: context,
        title: "Network Error",
        content: "Unable to connect to the internet!",
      );
    } catch (_) {
      alertDialog(
        context: context,
        title: "Oops! something went wrong.",
        content: "Contact support team",
      );
    }
    return freeServiceData;
  }

  getUserName() async {
    var name = await SecureStorage.storage.read(key: "userName");
    setState(() {
      userName = name;
    });
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: ListView(
        children: [
          FutureBuilder<List<FreeServiceModel>>(
            future: getFreeservices(),
            builder: (context, snapshot) {
              var data = snapshot.data;
              if (snapshot.hasData) {
                return CustomCarouselSlider.getCarouselSlider(
                  carouselItems: data!,
                );
              }
              if (snapshot.hasError) {
                return const ErrorText();
              }

              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSubTitle(text: "What are you looking for?"),
          ),
          _buildServiceBox(
            leftBoxImage: "vaccination.jpeg",
            leftBoxTitle: "Vaccination",
            leftBoxPage: const VaccinationScreen(),
            rightBoxImage: "pharmacy.jpeg",
            rightBoxTitle: "Pharmacy",
            rightBoxPage: const PharmacyScreen(),
          ),
          _buildServiceBox(
              leftBoxImage: "ambulance.jpeg",
              leftBoxTitle: "Ambulance",
              leftBoxPage: const AmbulanceScreen(),
              rightBoxImage: "bloodbank.jpeg",
              rightBoxTitle: "BloodBank",
              rightBoxPage: const BloodBankScreen()),
          _buildServiceBox(
              leftBoxImage: "hospital.jpeg",
              leftBoxTitle: "Hospital",
              leftBoxPage: const HospitalScreen(),
              rightBoxImage: "diagnostics.jpeg",
              rightBoxTitle: "Diagnostics",
              rightBoxPage: const DiagnosticsScreen()),
        ],
      ),
    );
  }

  _buildServiceBox({
    required String leftBoxTitle,
    required String rightBoxTitle,
    required String leftBoxImage,
    required String rightBoxImage,
    Widget? leftBoxPage,
    Widget? rightBoxPage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 15, right: 8, bottom: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => leftBoxPage!,
                  ),
                );
              },
              child: SizedBox(
                height: 120,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.amber,
                  child: GridTile(
                    footer: GridTileBar(
                      title: Text(leftBoxTitle),
                      backgroundColor: Colors.black54,
                    ),
                    child: Ink.image(
                      image: AssetImage("assets/images/$leftBoxImage"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, top: 15, right: 16, bottom: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => rightBoxPage!,
                  ),
                );
              },
              child: SizedBox(
                height: 120,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.amber,
                  child: GridTile(
                    footer: GridTileBar(
                      title: Text(rightBoxTitle),
                      backgroundColor: Colors.black54,
                    ),
                    child: Ink.image(
                      image: AssetImage("assets/images/$rightBoxImage"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text("Hi, $userName", style: kAuthSubtitleTextStyle),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.account_circle,
            color: kRedColor,
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildSubTitle(
                text: "Free Services",
              )
            ],
          ),
        ),
        preferredSize: const Size.fromHeight(
          30,
        ),
      ),
    );
  }
}
