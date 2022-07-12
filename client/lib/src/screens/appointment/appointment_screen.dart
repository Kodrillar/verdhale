import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verdhale/src/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:verdhale/src/components/button/auth_button.dart';
import 'package:verdhale/src/components/error/error_widget.dart';
import 'package:verdhale/src/models/appointment_model.dart';
import 'package:verdhale/src/models/current_user_model.dart';
import 'package:verdhale/src/repository/appointment_repository.dart';
import 'package:verdhale/src/repository/current_user_repository.dart';
import 'package:verdhale/src/screens/appointment/book_appointment_screen.dart';
import 'package:verdhale/src/services/api.dart';
import 'package:verdhale/src/services/appointment_service.dart';
import 'package:verdhale/src/utils/constant.dart';
import 'package:verdhale/src/utils/secure_storage.dart';
import '../../components/alert_dialog.dart';
import '../../models/validation_error_model.dart';

CurrentUserRepository _currentUserRepository = CurrentUserRepository();
AppointmentRepository _appointmentRepository = AppointmentRepository();

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController aIdController = TextEditingController();

  dynamic userData;
  dynamic appointmentData;

  Future<List<AppointmentModel>> getAppointment() async {
    try {
      appointmentData = await _appointmentRepository.getAppointment(
          endpoint: endpoints["appointment"]);
    } on SocketException {
      alertDialog(
        context: context,
        title: "Network Error",
        content: "Unable to connect to the internet!",
      );
    } //Excluding 'catch' because I want future builder(snapshot.hasError) to handle error
    // catch (ex) {
    //   alertDialog(
    //     context: context,
    //     title: "Oops! something went wrong.",
    //     content: "Contact support team",
    //   );
    // }

    return appointmentData;
  }

  Future<CurrentUserModel> getFullname() async {
    try {
      userData = await _currentUserRepository.getCurrentUser(
        endpoint: endpoints["getCurrentUser"],
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

    return userData;
  }

  bool processingRequest = false;
  String? emailErrorText;
  String? aIdErrorText;

  String? username;
  String? fullname;

  getUsername() async {
    var name = await SecureStorage.storage.read(key: "userName");
    setState(() {
      username = name;
      emailController = TextEditingController(text: username);
    });
  }

  joinAppointment() {
    AppointmentService.createAppointment(
      aId: aIdController.text.trim(),
      email: emailController.text.trim(),
      name: fullname,
    );
  }

  @override
  void initState() {
    getUsername();
    getFullname().then((value) {
      setState(() {
        fullname = value.fullname;
      });
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   aIdController.dispose();
  //   emailController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: _buildTextField(
                controller: emailController,
                onChanged: onChangedOfTextField(emailController),
                label: "email",
                errorText: emailErrorText),
          ),
          _buildTextField(
              label: "Appointment ID",
              onChanged: onChangedOfTextField(aIdController),
              controller: aIdController,
              errorText: aIdErrorText),
          _buildAppointmentAction(),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 60,
            ),
            child: buildSubTitle(text: "Recently booked"),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            height: 250,
            child: FutureBuilder<List<AppointmentModel>>(
              future: getAppointment(),
              builder: (context, snapshot) {
                var data = snapshot.data;
                if (snapshot.hasData) {
                  return _buildAppointmentList(appointmentData: data!);
                }
                if (snapshot.hasError) {
                  return const ErrorBox(
                    text: "Oops! No appointment(s)",
                  );
                }

                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildAppointmentList({required List<AppointmentModel> appointmentData}) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: appointmentData.length,
      itemBuilder: (context, index) => ListTile(
        title: Text("ID: ${appointmentData[index].aid}"),
        subtitle: Text(
          _formatDate(appointmentData[index].date),
        ),
        trailing: Text(
          appointmentData[index].time,
        ),
      ),
    );
  }

  _formatDate(String date) {
    final DateTime dateToBeFromatted = DateTime.parse(date);
    final DateFormat dateFormatter = DateFormat("dd MMM, y");
    final String formattedDate = dateFormatter.format(dateToBeFromatted);
    return formattedDate;
  }

  buildSubTitle({required String text}) {
    return Text(
      text,
      style: kAuthSubtitleTextStyle.copyWith(
        fontSize: 17,
        color: kRedColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _buildAppointmentAction() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: processingRequest
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
              : AuthButton(
                  buttonName: "Join Appointment",
                  onTap: () {
                    setState(() {
                      processingRequest = true;
                    });

                    textFieldValidationLogic();
                  },
                ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BookAppointmentScreen(
                email: username!,
              );
            }));
          },
          child: const Text(
            "Don't have ID? Book Appointment",
            style: kAuthOptionTextStyle,
          ),
        )
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Appointment",
        style: kAppBarTextStyle,
      ),
    );
  }

  _buildTextField({
    required String label,
    required TextEditingController controller,
    required onChanged,
    required errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            fillColor: kGreenColor.withOpacity(.1),
            filled: true,
            border: InputBorder.none,
            labelText: label,
            errorText: errorText),
        onChanged: onChanged,
      ),
    );
  }

  onChangedOfTextField(TextEditingController controller) {
    return (newValue) {
      setState(() {
        controller == emailController && controller.text.trim().isNotEmpty
            ? emailErrorText = null
            : null;

        controller == aIdController && controller.text.trim().isNotEmpty
            ? aIdErrorText = null
            : null;
      });
    };
  }

  void textFieldValidationLogic() async {
    if (emailController.text.trim().isEmpty) {
      setState(() {
        processingRequest = false;
        emailErrorText = ValidationErrorModel.validationError["emailError"];
      });

      return;
    }

    if (aIdController.text.trim().isEmpty) {
      setState(() {
        processingRequest = false;
        aIdErrorText = ValidationErrorModel.validationError["aIdError"];
      });
      return;
    }
    joinAppointment();
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        processingRequest = false;
      });
    });
  }
}
