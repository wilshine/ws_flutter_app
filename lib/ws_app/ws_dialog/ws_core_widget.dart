import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

SingletonFlutterWindow getWindow() {
// return getWidgetsBinding().window;
  return window;
}

WidgetsBinding getWidgetsBinding() {
// remove the ! not-null sign, if you want to support Flutter v3.x.x SDK
  return WidgetsBinding.instance;
}

/// Widget for setSate & init & dispose callback
class BuilderEx extends StatefulWidget {
  final String? name;
  final Function(State state) builder;
  final Function(State state)? init, dispose;

  const BuilderEx({Key? key, required this.builder, this.name, this.init, this.dispose}) : super(key: key);

  @override
  State createState() => BuilderExState();
}

class BuilderExState extends State<BuilderEx> {
  @override
  void initState() {
    BuilderExState.callWidgetInit(widget, this);
    super.initState();
  }

  static void callWidgetInit(BuilderEx widget, State state) {
    try {
      widget.init?.call(state);
    } catch (e, s) {
      print('[$state] ${widget.name} showCallBack exception: ${e.toString()}');
      print(e is Error ? e.stackTrace?.toString() ?? 'No stackTrace' : 'No stackTrace');
      print(s.toString());
    }
    assert(() {
      print('[$state] ${widget.name} >>>>> initState');
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    return BuilderExState.callWidgetBuilder(widget, this);
  }

  static Widget callWidgetBuilder(BuilderEx widget, State state) {
    assert(() {
      print('[$state] ${widget.name} >>>>> build');
      return true;
    }());
    return widget.builder(state);
  }

  @override
  void dispose() {
    BuilderExState.callWidgetDispose(widget, this);
    super.dispose();
  }

  static void callWidgetDispose(BuilderEx widget, State state) {
    try {
      widget.dispose?.call(state);
    } catch (e, s) {
      print('[$state] ${widget.name} dismissCallBack exception: ${e.toString()}');
      print(e is Error ? e.stackTrace?.toString() ?? 'No stackTrace' : 'No stackTrace');
      print(s.toString());
    }
    assert(() {
      print('[$state] ${widget.name} >>>>> dispose');
      return true;
    }());
  }
}

/// Widget for setSate & ticker animation
class BuilderWithTicker extends BuilderEx {
  const BuilderWithTicker({
    Key? key,
    String? name,
    Function(State state)? init,
    Function(State state)? dispose,
    required Function(State state) builder,
  }) : super(key: key,
      builder: builder,
      name: name,
      init: init,
      dispose: dispose);

  @override
  State createState() => BuilderWithTickerState();
}

// Do not extends BuilderExState with a mixin ❗️ Cause it parent class will be TickerProviderStateMixin$BuilderExState -> BuilderExState
// We need to call widget dispose first, otherwise will call TickerProviderStateMixin dipose method first ❗️❗️
class BuilderWithTickerState extends State<BuilderWithTicker> with TickerProviderStateMixin {
  @override
  void initState() {
    BuilderExState.callWidgetInit(widget, this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BuilderExState.callWidgetBuilder(widget, this);
  }

  @override
  void dispose() {
    BuilderExState.callWidgetDispose(widget, this);
    super.dispose();
  }
}

/// Widget for get Size immediately
class GetSizeWidget extends SingleChildRenderObjectWidget {
  final void Function(RenderBox box, Size? legacy, Size size) onLayoutChanged;

  const GetSizeWidget({Key? key, required Widget child, required this.onLayoutChanged}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    print('[$runtimeType] createRenderObject');
    return _GetSizeRenderObject()
      ..onLayoutChanged = onLayoutChanged;
  }
}

class _GetSizeRenderObject extends RenderProxyBox {
  Size? _size;
  late void Function(RenderBox box, Size? legacy, Size size) onLayoutChanged;

  @override
  void performLayout() {
    super.performLayout();

    Size? size = child?.size;
    print('[$runtimeType] performLayout >>>>>>>>> size: $size');
        bool isSizeChanged = size != null && size != _size;
        if (isSizeChanged)
    {
      _invoke(_size, size);
    }
    if (isSizeChanged) {
      _size = size;
    }
  }

  void _invoke(Size? legacy, Size size) {
    getWidgetsBinding().addPostFrameCallback((timeStamp) {
      onLayoutChanged.call(this, legacy, size);
    });
  }
}