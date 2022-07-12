import 'package:flutter/material.dart';
import 'package:verdhale/src/utils/constant.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.keyboardType,
    this.errorText,
    this.labelText,
    this.visibilityIcon,
    this.obscureText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final String? labelText;
  final Widget? visibilityIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final void Function(String value)? onChanged;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kLightRedColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          keyboardType: widget.keyboardType ?? TextInputType.text,
          onChanged: widget.onChanged,
          controller: widget.controller,
          obscureText: widget.obscureText ?? false,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: kGreenColor.withOpacity(.6),
            ),
            hintText: widget.hintText,
            suffixIcon: widget.visibilityIcon,
            errorText: widget.errorText,
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
}
