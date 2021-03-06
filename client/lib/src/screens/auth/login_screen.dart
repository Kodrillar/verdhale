import 'dart:io';

import 'package:flutter/material.dart';
import 'package:verdhale/src/repository/auth/auth_repository.dart';
import 'package:verdhale/src/screens/auth/signup_screen.dart';

import '../../components/alert_dialog.dart';
import '../../components/auth_option_text.dart';
import '../../components/button/auth_button.dart';
import '../../components/custom_textfield.dart';
import '../../models/validation_error_model.dart';
import '../../services/api.dart';
import '../../utils/constant.dart';
import '../../utils/secure_storage.dart';
import '../home_screen.dart';

AuthRepository _authRepository = AuthRepository();

class LoginScreen extends StatefulWidget {
  static const id = "/loginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? emailErrorText;
  String? passwordErrorText;
  bool processingRequest = false;
  bool obscureTextField = true;

  Future<Map<String, dynamic>> loginUser() async {
    var loginData = await _authRepository.loginUser(
      endpoint: endpoints["loginUser"],
      userEmail: emailController.text.trim(),
      userPassword: passwordController.text.trim(),
    );
    return loginData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 120),
              child: Text(
                "Login",
                style: kAuthTextStyle,
              ),
            ),
          ),
          CustomTextField(
            labelText: "email",
            hintText: "email",
            controller: emailController,
            errorText: emailErrorText,
            onChanged: onChangedOfTextField(emailController),
          ),
          CustomTextField(
            labelText: "password",
            hintText: "password",
            controller: passwordController,
            errorText: passwordErrorText,
            obscureText: obscureTextField,
            visibilityIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureTextField = !obscureTextField;
                });
              },
              icon: obscureTextField
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
            ),
            onChanged: onChangedOfTextField(passwordController),
          ),
          processingRequest
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: kGreenColor,
                    ),
                  ),
                )
              : AuthButton(
                  buttonName: "Login",
                  onTap: () {
                    //to prevent 'processingRequest from always becoming 'true:'
                    //set processingRequest to be 'true' before calling 'textFieldValidation logic '
                    setState(() {
                      processingRequest = true;
                    });
                    textFieldValidationLogic();
                  },
                ),
          AuthOptionText(
            title: "New to Verdhale?",
            optionText: "Sign Up",
            optionTextStyle: kAuthOptionTextStyle.copyWith(
              color: kGreenColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, SignUpScreen.id);
            },
          )
        ],
      ),
    );
  }

  onChangedOfTextField(TextEditingController controller) {
    return (newValue) {
      setState(() {
        controller == emailController && controller.text.trim().isNotEmpty
            ? emailErrorText = null
            : null;

        controller == passwordController && controller.text.trim().isNotEmpty
            ? passwordErrorText = null
            : null;
      });
    };
  }

  void textFieldValidationLogic() async {
    // Refactor all controller.text to a single variable;
    if (emailController.text.trim().isEmpty) {
      setState(() {
        processingRequest = false;
        emailErrorText = ValidationErrorModel.validationError["emailError"];
      });

      return;
    }

    if (passwordController.text.trim().isEmpty) {
      setState(() {
        processingRequest = false;
        passwordErrorText =
            ValidationErrorModel.validationError["passwordError"];
      });
      return;
    }
    try {
      var userData = await loginUser();

      if (userData["userAlreadyExist"] == false) {
        setState(() {
          emailErrorText = "User does not exist! Kindly Sign up...";

          processingRequest = false;
        });
        return;
      }
      ;
      if (userData["wrongPassword"] == true) {
        setState(() {
          passwordErrorText = "Wrong/Invalid passowrd!";

          processingRequest = false;
        });
        return;
      }
      ;

      await SecureStorage.storage.write(key: "token", value: userData["token"]);
      await SecureStorage.storage
          .write(key: "userName", value: emailController.text.trim());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen(),
          ),
          (route) => false);
    } on SocketException {
      setState(() {
        processingRequest = false;
      });
      alertDialog(
        context: context,
        title: "Network Error",
        content: "Unable to connect to the internet!",
      );
    } catch (_) {
      setState(() {
        processingRequest = false;
      });
      alertDialog(
        context: context,
        title: "Internal Error",
        content: "Server Error, try again!",
      );
    }
  }
}
