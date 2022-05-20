import 'package:flutter/material.dart';

import '../../components/bottom_navigation_bar/flow_bottom_navigation_bar.dart';
import '../../components/button/auth_button.dart';
import '../../components/dropdown_filter.dart';
import '../../components/payment_bottom_sheet.dart';
import '../../models/salary_model.dart';
import '../../utils/constant.dart';

class PharmacyDiscountScreen extends StatefulWidget {
  const PharmacyDiscountScreen({
    Key? key,
    required this.price,
  }) : super(key: key);

  final double price;

  @override
  _PharmacyDiscountScreenState createState() => _PharmacyDiscountScreenState();
}

class _PharmacyDiscountScreenState extends State<PharmacyDiscountScreen> {
  List<String> salaries = SalaryModel.salary;

  late String dropdownValue;
  TextEditingController discountTextController = TextEditingController();
  String? errorText;

  int servicePrice = 0;
  int discountPrice = 0;
  bool isLessThanMininmum = false;

  @override
  void initState() {
    setState(() {
      servicePrice = widget.price.toInt();
      discountPrice = servicePrice;
    });
    dropdownValue = salaries[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomAppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _buildSubTitle(text: "Age range"),
              ),
            ],
          ),
          const DropdownFilter(
            dropdownItems: ["Adult", "Minor"],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _buildSubTitle(
                    text: "Salary range(Parent/Guardian)",
                  )),
            ],
          ),
          _buildDiscountFilter(),
          isLessThanMininmum ? _discountTextField() : const SizedBox(),
        ],
      ),
    );
  }

  _handleDiscount(salaryValue) {
    var discount = 0.0;
    if (salaryValue == salaries[1]) {
      setState(() {
        isLessThanMininmum = true;
      });
    } else if (salaryValue == salaries[2]) {
      setState(() {
        isLessThanMininmum = false;
        discount = servicePrice * 75 / 100;
        discountPrice = discount.toInt();
      });
    } else if (salaryValue == salaries[3]) {
      setState(() {
        isLessThanMininmum = false;
        discount = servicePrice * 80 / 100;
        discountPrice = discount.toInt();
      });
    } else if (salaryValue == salaries[4]) {
      setState(() {
        isLessThanMininmum = false;
        discount = servicePrice * 85 / 100;
        discountPrice = discount.toInt();
      });
    } else if (salaryValue == salaries[5]) {
      setState(() {
        isLessThanMininmum = false;
        discount = servicePrice * 90 / 100;
        discountPrice = discount.toInt();
      });
    } else if (salaryValue == salaries[6]) {
      setState(() {
        isLessThanMininmum = false;
        discount = servicePrice * 95 / 100;
        discountPrice = discount.toInt();
      });
    } else {
      setState(() {
        isLessThanMininmum = false;
        discountPrice = servicePrice;
      });
    }
  }

  _buildDiscountFilter() {
    return Container(
      margin: const EdgeInsets.only(
        top: 15,
        right: 30,
        left: 30,
        bottom: 25,
      ),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: kRedColor,
          width: 2,
        ),
      ),
      child: Center(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          items: salaries
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
            _handleDiscount(newValue);
          },
          value: dropdownValue,
        ),
      ),
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

  _buildBottomAppBar() {
    return FlowBottomNavigationBar(
      child: AuthButton(
        onTap: () async {
          showModalBottomSheet(
            context: context,
            builder: (context) => const PaymentBottomSheet(),
          );
        },
        buttonName: "Pay \$$discountPrice",
      ),
    );
  }

  _discountTextField() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kLightRedColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: (String newPrice) {
            if (newPrice.trim().isNotEmpty) {
              setState(() {
                discountPrice = int.tryParse(newPrice.trim()) ?? 1;
              });
            } else {
              setState(() {
                discountPrice = 1;
              });
            }
          },
          controller: discountTextController,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: kGreenColor.withOpacity(.6),
            ),
            hintText: "Pay what you have",
            labelText: "Pay what you have",
            errorText: errorText,
            errorStyle: kAuthSubtitleTextStyle.copyWith(
              color: kGreenColor,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
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
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: _buildSubTitle(
            text: "Price: \$$servicePrice",
          ),
        ),
      ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Additional Info",
        style: kAppBarTextStyle,
      ),
    );
  }
}
