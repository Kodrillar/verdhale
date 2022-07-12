import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:verdhale/src/components/button/auth_button.dart';
import 'package:verdhale/src/utils/constant.dart';

import '../../services/api.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productDescription,
  });

  final String productImage;
  final String productPrice;
  final String productName;
  final String productDescription;

  static const id = "/productScreen";

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int productQuantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: [
          _buildProductImage(),
          _buildProductDetails(),
          _buildProductQuantity(),
          _buildProductButtons(),
        ],
      ),
    );
  }

  _buildProductButtons() {
    return SizedBox(
      height: 100,
      child: AuthButton(
        onTap: () {
          addProductToCart();
        },
        buttonName: "Add to cart",
      ),
    );
  }

  void addProductToCart() {
    _showSnackBar();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CartScreen(
            image: widget.productImage,
            quantity: productQuantity,
            price: widget.productPrice,
            name: widget.productName,
          );
        },
      ),
    );
  }

  _showSnackBar([String? additionalMessage]) {
    SnackBar snackBar = SnackBar(
      backgroundColor: kGreenColor,
      content: Row(
        children: [
          const Icon(
            Icons.add_shopping_cart_sharp,
            color: kRedColor,
          ),
          const SizedBox(width: 5),
          Text(
            "${widget.productName} added to ${additionalMessage ?? ''} cart!",
            style: kSnackBarTextStyle,
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _buildProductQuantity() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quantity", style: kAppBarTextStyle),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$productQuantity',
                  style: kAppBarTextStyle.copyWith(color: kRedColor),
                ),
                Row(
                  children: [
                    Container(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (productQuantity > 1) {
                              productQuantity--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove),
                        color: kYellowColor,
                      ),
                      decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            productQuantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                        color: kYellowColor,
                      ),
                      decoration: BoxDecoration(
                        color: kGreenColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildProductDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.productName,
                style: kProductNameStyle,
              ),
              Text(
                "\$${widget.productPrice}",
                style: kProductNameStyle,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            widget.productDescription,
            textAlign: TextAlign.justify,
            style: kProductDetailStyle,
          )
        ],
      ),
    );
  }

  _buildProductImage() {
    return CachedNetworkImage(
      imageUrl: "${API.baseUrl}/uploads/${widget.productImage}",
      imageBuilder: (context, imageProvider) => Container(
        margin: const EdgeInsets.all(16),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: kGreenColor.withOpacity(.075),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(Icons.error, color: Colors.red),
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

      // ],
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Pharmacy",
        style: kAppBarTextStyle,
      ),
    );
  }
}
