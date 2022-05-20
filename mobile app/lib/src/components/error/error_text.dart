import 'package:flutter/material.dart';

import '../../utils/constant.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Icon(
            Icons.error,
            color: kGreenColor.withOpacity(.35),
            size: 100,
          ),
          height: 150,
        ),
        const Text(
          "Oops! something went wrong \n",
          style: kAppBarTextStyle,
        )
      ],
    );
  }
}
