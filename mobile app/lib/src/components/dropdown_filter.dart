import 'package:flutter/material.dart';
import 'package:verdhale/src/utils/constant.dart';

class DropdownFilter extends StatefulWidget {
  const DropdownFilter({required this.dropdownItems, Key? key})
      : super(key: key);
  final List<String> dropdownItems;

  @override
  _DropdownFilterState createState() => _DropdownFilterState();
}

class _DropdownFilterState extends State<DropdownFilter> {
  late String dropdownValue;
  @override
  void initState() {
    dropdownValue = widget.dropdownItems[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          items: widget.dropdownItems
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
}
