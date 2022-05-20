import 'dart:io';

import 'package:verdhale/src/screens/auth/login_screen.dart';

import '../../components/alert_dialog.dart';
import '../../components/auth_option_text.dart';
import '../../components/button/auth_button.dart';
import '../../components/custom_textfield.dart';
import '../../models/validation_error_model.dart';
import '../../repository/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api.dart';
import '../../utils/constant.dart';
import '../../utils/secure_storage.dart';
import '../home_screen.dart';

AuthRepository _authRepository = AuthRepository();

class SignUpScreen extends StatefulWidget {
  static const id = "/signupScreen";
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  dynamic _imageFile;

  String? fullnameErrorText;
  String? emailErrorText;
  String? passwordErrorText;

  String? uploadImageErrorText;

  bool processingRequest = false;
  bool obscureTextField = true;

  Future signUp() async {
    var responseBody = await _authRepository.registerUser(
      endpoint: endpoints["registerUser"],
      userFullname: fullnameController.text,
      userPassword: passwordController.text.trim(),
      userEmail: emailController.text.trim(),
    );
    return responseBody;
  }

  Future<void> uploadProfileImage() async {
    await _authRepository.uploadProfileImage(
      endpoint: endpoints["uploadProfileImage"],
      imagePath: _imageFile.path,
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    fullnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "Sign Up",
                style: kAuthTextStyle,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => showBottomSheet(),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 115),
              height: 110,
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: _imageProvider(), fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(80),
              ),
              child: Stack(children: [
                Positioned(
                  bottom: 5,
                  left: 52,
                  child: Icon(
                    Icons.image,
                    color: kRedColor.withOpacity(.3),
                  ),
                ),
              ]),
            ),
          ),
          Center(
            child: Text(
              uploadImageErrorText ?? "",
              style: kAuthSubtitleTextStyle.copyWith(color: kRedColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Biodata",
                  style: kAuthSubtitleTextStyle,
                ),
              ],
            ),
          ),
          CustomTextField(
            hintText: "fullname",
            labelText: "fullname",
            controller: fullnameController,
            errorText: fullnameErrorText,
            onChanged: onChanged(fullnameController),
          ),
          CustomTextField(
            hintText: "email",
            labelText: "email",
            controller: emailController,
            errorText: emailErrorText,
            onChanged: onChanged(emailController),
          ),
          CustomTextField(
            hintText: "password",
            labelText: "password",
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
            onChanged: onChanged(passwordController),
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
                  buttonName: "Sign Up",
                  onTap: () async {
                    setState(() {
                      processingRequest = true;
                    });
                    textFieldValidationLogic();
                  },
                ),
          AuthOptionText(
            title: "Already have an account?",
            optionText: "Login",
            optionTextStyle: kAuthOptionTextStyle.copyWith(
              color: kGreenColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
          )
        ],
      ),
    );
  }

  onChanged(TextEditingController controller) {
    return (newValue) {
      setState(() {
        // print(controller.text);
        controller == fullnameController && controller.text.trim().isNotEmpty
            ? fullnameErrorText = null
            : null;

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
    if (fullnameController.text.trim().isEmpty) {
      setState(() {
        fullnameErrorText =
            ValidationErrorModel.validationError["fullnameError"];
        processingRequest = false;
      });
      return;
    }

    if (emailController.text.trim().isEmpty) {
      setState(() {
        emailErrorText = ValidationErrorModel.validationError["emailError"];
        processingRequest = false;
      });

      return;
    }

    if (passwordController.text.trim().isEmpty) {
      setState(() {
        passwordErrorText =
            ValidationErrorModel.validationError["passwordError"];
        processingRequest = false;
      });

      return;
    }

    if (_imageFile == null) {
      setState(() {
        uploadImageErrorText = "Kindly select a profile image!";
        processingRequest = false;
      });
      return;
    } else {
      setState(() {
        uploadImageErrorText = "";
        processingRequest = false;
      });
    }

    try {
      var userData = await signUp();

      if (userData["userAlreadyExist"]) {
        setState(() {
          emailErrorText = "email is already registered! Kindly LogIn...";

          processingRequest = false;
        });

        return;
      }
      await SecureStorage.storage.write(key: "token", value: userData["token"]);
      try {
        uploadProfileImage().whenComplete(
          () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen(),
              ),
              (route) => false),
        );
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

      await SecureStorage.storage
          .write(key: "userName", value: emailController.text.trim());
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

  ImageProvider _imageProvider() {
    if (_imageFile != null) {
      return FileImage(
        File(_imageFile.path),
      );
    } else {
      return const AssetImage(
        "assets/images/profile.png",
      );
    }
  }

  showBottomSheet() {
    return Container(
      height: 120,
      color: kLightColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            highlightColor: kGreenColor,
            onTap: () {
              pickImage(ImageSource.gallery);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.image,
                  color: kRedColor,
                ),
                Text(
                  "Gallery",
                  style: kAppBarTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              pickImage(ImageSource.camera);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.camera,
                  color: kRedColor,
                ),
                Text(
                  "Camera",
                  style: kAppBarTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.normal),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void pickImage(ImageSource imageSource) async {
    var pickedImage =
        await _imagePicker.pickImage(source: imageSource).whenComplete(
              () => Navigator.pop(context),
            );
    setState(() {
      _imageFile = pickedImage;
    });
  }
}
