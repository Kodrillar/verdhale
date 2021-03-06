import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:verdhale/src/components/button/auth_button.dart';
import 'package:verdhale/src/screens/pharmacy/shipping_info_screen.dart';
import 'package:verdhale/src/utils/constant.dart';

import '../../services/api.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    required this.image,
    required this.price,
    required this.quantity,
    required this.name,
  });

  final String image;
  final String price;
  final  quantity;
  final String name;

  static const id = "/cartScreen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomAppBar(),
      body: _buildCartBar(),
    );
  }

  _buildCartBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      height: 150,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: CachedNetworkImage(
                imageUrl: "${API.baseUrl}/uploads/${widget.image}",
                imageBuilder: (context, imageProvider) => Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kGreenColor.withOpacity(.08),
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
              ),
            ),
          ),
          Text(
            "\$${widget.price} X ${widget.quantity}",
            style: kAppBarTextStyle,
          )
        ],
      ),
    );
  }

  _buildBottomAppBar() {
    var totalPrice = double.parse(widget.price) * widget.quantity;

    return BottomAppBar(
      elevation: 0,
      child: SizedBox(
        height: 180,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: kProductNameStyle,
                  ),
                  Text(
                    "\$${totalPrice.floor()}",
                    style: kProductNameStyle.copyWith(
                      color: kGreenColor,
                    ),
                  )
                ],
              ),
              AuthButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShippingInfoScreen(
                        image: widget.image,
                        price: totalPrice,
                        name: widget.name,
                      ),
                    ),
                  );
                },
                buttonName: "Checkout",
              )
            ],
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
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text(
        "Cart",
        style: kAppBarTextStyle,
      ),
    );
  }
}
