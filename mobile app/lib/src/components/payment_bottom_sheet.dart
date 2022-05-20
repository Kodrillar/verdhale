import 'package:flutter/material.dart';
import 'package:verdhale/src/components/button/auth_button.dart';
import 'package:verdhale/src/components/custom_textfield.dart';
import 'package:verdhale/src/screens/home_screen.dart';
import 'package:verdhale/src/utils/constant.dart';

import '../models/validation_error_model.dart';

class PaymentBottomSheet extends StatefulWidget {
  const PaymentBottomSheet({Key? key}) : super(key: key);

  @override
  _PaymentBottomSheetState createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expiryController = TextEditingController();

  String? errorText;

  bool processingRequest = false;
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return BottomSheet(
      backgroundColor: Colors.transparent,
      onClosing: () {},
      builder: (BuildContext context) => Container(
        height: _height * .7,
        decoration: const BoxDecoration(
          color: kLightColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ListView(
            children: [
              CustomTextField(
                controller: cardNameController,
                hintText: "Cardholder Name",
                labelText: "Cardholder Name",
                errorText: errorText,
              ),
              CustomTextField(
                controller: cardNumberController,
                hintText: "Card Number",
                labelText: "Card Number",
                errorText: errorText,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: cvvController,
                        hintText: "CVV code",
                        labelText: "CVV code",
                        errorText: errorText,
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
                        controller: expiryController,
                        hintText: "Expiration Date",
                        labelText: "Expiration Date",
                        errorText: errorText,
                      ),
                    ),
                  ],
                ),
              ),
              processingRequest
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : AuthButton(
                      onTap: () {
                        setState(() {
                          processingRequest = true;
                        });
                        textFieldValidationLogic();
                      },
                      buttonName: "Pay",
                    ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "secured by",
                      style: kAuthOptionTextStyle,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Stripe",
                      style: kAuthOptionTextStyle.copyWith(color: Colors.blue),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void textFieldValidationLogic() async {
    if (cardNameController.text.trim().isEmpty) {
      setState(() {
        processingRequest = false;
        errorText = ValidationErrorModel.validationError["cardError"];
      });

      return;
    }

    if (cardNumberController.text.trim().isEmpty) {
      setState(() {
        processingRequest = false;
        errorText = ValidationErrorModel.validationError["cardError"];
      });
      return;
    }
    if (cvvController.text.trim().isEmpty) {
      setState(() {
        processingRequest = false;
        errorText = ValidationErrorModel.validationError["cardError"];
      });
      return;
    }
    if (expiryController.text.trim().isEmpty) {
      setState(() {
        processingRequest = false;
        errorText = ValidationErrorModel.validationError["cardError"];
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        processingRequest = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
  }
}
