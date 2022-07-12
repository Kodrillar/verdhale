import 'package:flutter/material.dart';

import 'package:verdhale/src/utils/constant.dart';

class VaccinationCard extends StatefulWidget {
  const VaccinationCard({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final String title;
  final void Function()? onTap;
  @override
  _VaccinationCardState createState() => _VaccinationCardState();
}

class _VaccinationCardState extends State<VaccinationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 100,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          shadowColor: Colors.black54,
          elevation: 4,
          child: ListTile(
            title: Text(
              widget.title,
              style: kProductNameStyle,
            ),
            subtitle: const Text(
              "Onsite",
              style: kProductDetailStyle,
            ),
          ),
        ),
      ),
    );
  }
}
