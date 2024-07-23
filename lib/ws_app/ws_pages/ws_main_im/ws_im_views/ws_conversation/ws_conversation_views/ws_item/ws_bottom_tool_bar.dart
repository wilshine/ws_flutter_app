import 'package:flutter/material.dart';
import '../../util/ws_style.dart';
import 'dart:developer' as developer;

class WSBottomToolBar extends StatefulWidget {
  final WSBottomToolBarDelegate delegate;
  WSBottomToolBar({required this.delegate});

  @override
  State<StatefulWidget> createState() {
    return _WSBottomToolBarState();
  }
}

class _WSBottomToolBarState extends State<WSBottomToolBar> {
  String pageName = "example.BottomToolBar";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            iconSize: WSRCLayout.BottomIconLayoutSize,
            onPressed: () {
              tapDelete();
            },
          ),
          IconButton(
            icon: Icon(Icons.forward),
            iconSize: WSRCLayout.BottomIconLayoutSize,
            onPressed: () {
              tapForward();
            },
          ),
        ],
      ),
    );
  }

  void tapDelete() {
    if (widget.delegate != null) {
      widget.delegate.didTapDelete();
    } else {
      developer.log("no BottomToolBarDelegate", name: pageName);
    }
  }

  void tapForward() {
    if (widget.delegate != null) {
      widget.delegate.didTapForward();
    } else {
      developer.log("no BottomToolBarDelegate", name: pageName);
    }
  }
}

abstract class WSBottomToolBarDelegate {
  void didTapDelete();
  void didTapForward();
}
