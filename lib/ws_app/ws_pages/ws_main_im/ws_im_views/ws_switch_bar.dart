import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WSSwitchBar extends StatefulWidget {
  WSSwitchBar({
    super.key,
    required this.tabs,
    this.selectedValue,
    required this.onEventTapped,
  });

  final List tabs;
  dynamic selectedValue;
  final Function(int i, dynamic value) onEventTapped;

  @override
  State<WSSwitchBar> createState() => _WSSwitchBarState();
}

class _WSSwitchBarState extends State<WSSwitchBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < widget.tabs.length; i++) {
      dynamic v = widget.tabs[i];

      Widget textWidget = Text(
        v,
        style: TextStyle(
          fontSize: v == widget.selectedValue ? 20 : 16,
          color: v != widget.selectedValue ? Color(0xFFFFFFFF) : Color(0xFF202020),
        ),
      );
      Widget itemWidget = Container(
        margin: EdgeInsets.only(top: 2, bottom: 2, left: 2, right: 2),
        decoration: v != widget.selectedValue
            ? null
            : BoxDecoration(
                color: const Color(0xFFFCFD55),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.04)),
                boxShadow: const [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.12), offset: Offset(0, 3), blurRadius: 8),
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.04), offset: Offset(0, 3), blurRadius: 2)
                ],
              ),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            widget.selectedValue = v;
            widget.onEventTapped(i, v);
            setState(() {});
          },
          child: textWidget,
        ),
      );
      children.add(Expanded(child: itemWidget));
    }

    return Container(
      margin: const EdgeInsets.only(left: 48, right: 48),
      decoration: BoxDecoration(color: const Color(0xFF1D150E), borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
