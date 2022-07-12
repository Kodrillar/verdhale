import 'package:flutter/material.dart';

import 'package:verdhale/src/utils/constant.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navigationButton(
            context: context,
            routeName: "/homeScreen",
            icon: const Icon(Icons.home_outlined),
          ),
          _navigationButton(
            context: context,
            routeName: "/appointmentScreen",
            icon: const Icon(Icons.people_outline),
          ),
        ],
      ),
    );
  }

  IconButton _navigationButton(
      {required Icon icon, required String routeName, required context}) {
    return IconButton(
      color: kGreenColor,
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          routeName,
          ModalRoute.withName('/'),
        );
      },
      icon: icon,
    );
  }
}
