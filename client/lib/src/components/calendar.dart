import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:verdhale/src/utils/constant.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({Key? key, required this.onDateSelected})
      : super(key: key);

  final void Function(DateTime date) onDateSelected;

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  @override
  Widget build(BuildContext context) {
    return Calendar(
      startOnMonday: true,
      selectedColor: kRedColor,
      todayColor: kRedColor,
      onDateSelected: widget.onDateSelected,
      events: const {},
      hideBottomBar: false,
      isExpanded: true,
      dayOfWeekStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: kGreenColor,
      ),
      weekDays: const [
        "Mon",
        "Tue",
        "Wed",
        "Thu",
        "Fri",
        "Sat",
        "Sun",
      ],
    );
  }
}
