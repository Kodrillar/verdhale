import 'package:flutter/material.dart';

import 'package:verdhale/src/components/button/auth_button.dart';
import 'package:verdhale/src/screens/pharmacy/pharmacy_discount_screen.dart';
import 'package:verdhale/src/utils/constant.dart';

import '../../components/custom_textfield.dart';

class ShippingInfoScreen extends StatefulWidget {
  const ShippingInfoScreen({this.price, this.image, this.name});

  final price;
  final image;
  final name;

  static const id = "/shippingInfo";

  @override
  _ShippingInfoScreenState createState() => _ShippingInfoScreenState();
}

class _ShippingInfoScreenState extends State<ShippingInfoScreen> {
  String? userEmail;

  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController apartmentController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();

  // void getUserEmail() async {
  //   var email = await SecureStorage.storage.read(key: "userName");
  //   setState(() {
  //     userEmail = email;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomAppBar(),
      body: ListView(
        children: [
          CustomTextField(
            controller: addressController,
            hintText: "Address",
            labelText: "Address",
          ),
          CustomTextField(
            controller: apartmentController,
            hintText: "Apartment suite(optional)",
            labelText: "Apartment suite",
          ),
          CustomTextField(
            controller: cityController,
            hintText: "City",
            labelText: "City",
          ),
          CustomTextField(
            controller: countryController,
            hintText: "Country",
            labelText: "Country",
          ),
          CustomTextField(
            controller: phoneController,
            hintText: "Phone",
            labelText: "Phone",
          ),
          CustomTextField(
            controller: zipCodeController,
            hintText: "Zip code",
            labelText: "Zip code",
          ),
        ],
      ),
    );
  }

  _buildBottomAppBar() {
    return BottomAppBar(
      elevation: 0,
      child: SizedBox(
        height: 120,
        child: Center(
          child: AuthButton(
            onTap: () {
              if (addressController.text.trim().isEmpty ||
                  cityController.text.trim().isEmpty ||
                  countryController.text.trim().isEmpty ||
                  phoneController.text.trim().isEmpty ||
                  zipCodeController.text.trim().isEmpty) {
                _showSnackBar(
                  message: "Fields not marked \nas 'optional' can't be empty!",
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PharmacyDiscountScreen(
                      price: widget.price,
                    ),
                  ),
                );
              }
            },
            buttonName: "Pay now",
          ),
        ),
      ),
    );
  }

  //Abstract this to a single widget
  void _showSnackBar({required String message, IconData? iconData}) {
    var _snackBar = SnackBar(
      content: Row(
        children: [
          Icon(iconData ?? Icons.error, color: kRedColor),
          const SizedBox(width: 5),
          Text(message, style: kSnackBarTextStyle),
        ],
      ),
      backgroundColor: kGreenColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
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
        "Shipping Infomation",
        style: kAppBarTextStyle,
      ),
    );
  }
}
