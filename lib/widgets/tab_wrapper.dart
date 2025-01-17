import 'package:flutter/material.dart';

class TabWrapper extends StatelessWidget {
  final Widget child;
  final int index;

  const TabWrapper({Key? key, required this.child, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // You can add any custom header or tab bar here if needed
        Expanded(child: child),
      ],
    );
  }
}
