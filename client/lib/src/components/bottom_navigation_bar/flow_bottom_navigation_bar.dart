import 'package:flutter/material.dart';

class FlowBottomNavigationBar extends StatefulWidget {
  const FlowBottomNavigationBar({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  _FlowBottomNavigationBarState createState() =>
      _FlowBottomNavigationBarState();
}

class _FlowBottomNavigationBarState extends State<FlowBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      child: SizedBox(
        height: 100,
        child: Column(
          children: [
            widget.child,
          ],
        ),
      ),
    );
  }
}
