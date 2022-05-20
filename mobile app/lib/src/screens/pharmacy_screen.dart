import 'dart:io';

import 'package:flutter/material.dart';

import '../components/alert_dialog.dart';
import '../components/pharmacy/product_card.dart';
import '../models/pharmacy/product_model.dart';
import '../repository/pharmacy/product_repository.dart';
import '../services/api.dart';
import '../utils/constant.dart';

ProductRepository _productRepository = ProductRepository();

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({Key? key}) : super(key: key);

  @override
  _PharmacyScreenState createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  String dropdownValue = "Antibiotics";
  List<String> dropdownItems = ProductModel.pharmacyProducts;

  var productData;

  Future<List<ProductModel>> getData(category) async {
    try {
      productData = await _productRepository.getProducts(
          endpoint: endpoints["getProducts"]! + category);
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
    return productData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          _buildFilter(),
          SizedBox(
            height: 450,
            child: FutureBuilder<List<ProductModel>>(
              future: getData(
                _categoryFilter(dropdownValue),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  return _buildProducts(data!);
                }
                if (snapshot.hasError) {
                  return _buildErrorWidget();
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildProducts(List<ProductModel> data) {
    return SizedBox(
      width: double.infinity,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
          mainAxisExtent: 215,
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 0.0,
        ),
        itemBuilder: (context, index) => ProductCard(
          productName: data[index].name,
          productImage: data[index].image,
          productDescription: data[index].description,
          productPrice: data[index].price,
        ),
      ),
    );
  }

  _buildFilter() {
    return Container(
      margin: const EdgeInsets.only(
        top: 50,
        right: 30,
        left: 30,
        bottom: 20,
      ),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: kGreenColor,
          width: 2,
        ),
      ),
      child: Center(
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          items: dropdownItems
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
          },
          value: dropdownValue,
        ),
      ),
    );
  }

  _categoryFilter(filter) {
    if (filter == dropdownItems[0]) {
      return "/antibiotics";
    } else if (filter == dropdownItems[1]) {
      return "/antimalarial";
    } else {
      return "/antidiabetics";
    }
  }

  _buildErrorWidget() {
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
          "Oops! No products found \nfor this category.",
          style: kAppBarTextStyle,
        )
      ],
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
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Pharmacy",
        style: kAppBarTextStyle,
      ),
    );
  }
}
