import 'package:flutter/material.dart';

import '../../utils/constant.dart';

class ErrorBox extends StatelessWidget {
  const ErrorBox({Key? key, required this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Icon(
            Icons.error,
            color: kRedColor.withOpacity(.35),
            size: 100,
          ),
          height: 150,
        ),
        Text(
          text,
          style: kAppBarTextStyle,
        )
      ],
    );
  }
}
