import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WSBaseStatefulWidget extends StatefulWidget {
  const WSBaseStatefulWidget({super.key, required this.title});

  final String title;

  @override
  State<WSBaseStatefulWidget> createState() => WSBaseStatefulWidgetState();
}

class WSBaseStatefulWidgetState extends State<WSBaseStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
