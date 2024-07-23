import 'package:flutter/material.dart';
import 'package:ws_flutter_app/ws_app/ws_dialog/ws_dialog_riser.dart';

typedef _ReInit = WSDialogRiser? Function(WSDialogRiser dialog);

class WSDialogActor {
  /// Riser basic usage in wrapper

  static WSDialogRiser showCenter(Widget child, {bool? fixed, double? width, double? height, String? key}) {
    WSDialogRiser dialog = show(child, fixed: fixed, width: width, height: height, key: key);
    dialog.transitionBuilder = RiserTransitionBuilder.fadeIn;
    return dialog;
  }

  static WSDialogRiser showRight(Widget child, {bool? fixed, double? width, double? height, String? key}) {
    WSDialogRiser dialog = show(child, width: width, height: height, key: key);
    if (fixed == true) {
      dialog.alignment = Alignment.topRight;
      dialog.padding = const EdgeInsets.only(top: -1, right: 16);
    } else {
      dialog.alignment = Alignment.centerRight;
      dialog.padding = const EdgeInsets.only(right: 16);
    }
    dialog.transitionBuilder = RiserTransitionBuilder.slideFromRight;
    return dialog;
  }

  static WSDialogRiser showLeft(Widget child, {bool? fixed, double? width, double? height, String? key}) {
    WSDialogRiser dialog = show(child, width: width, height: height, key: key);
    if (fixed == true) {
      dialog.alignment = Alignment.topLeft;
      dialog.padding = const EdgeInsets.only(top: -1, left: 16);
    } else {
      dialog.alignment = Alignment.centerLeft;
      dialog.padding = const EdgeInsets.only(left: 16);
    }
    dialog.transitionBuilder = RiserTransitionBuilder.slideFromLeft;
    return dialog;
  }

  static WSDialogRiser showTop(Widget child, {double? width, double? height, String? key}) {
    WSDialogRiser dialog = show(child, width: width, height: height, key: key);
    dialog.alignment = Alignment.topCenter;
    dialog.padding = const EdgeInsets.only(top: 16);
    dialog.transitionBuilder = RiserTransitionBuilder.slideFromTop;
    return dialog;
  }

  static WSDialogRiser showBottom(Widget child, {double? width, double? height, String? key}) {
    WSDialogRiser dialog = show(child, width: width, height: height, key: key);
    dialog.alignment = Alignment.bottomCenter;
    dialog.padding = const EdgeInsets.only(bottom: 16);
    dialog.transitionBuilder = RiserTransitionBuilder.slideFromBottom;
    return dialog;
  }

  static WSDialogRiser show(Widget child, {bool? fixed, double? x, double? y, double? width, double? height, String? key, _ReInit? init}) {
    WSDialogRiser dialog = WSDialogRiser();
    if (fixed == true) {
      dialog
        ..alignment = null
        ..padding = const EdgeInsets.only(left: -1, top: -1);
    }
    if (x != null && y != null) {
      dialog
        ..alignment = fixed == true ? null : Alignment.topLeft
        ..padding = EdgeInsets.only(left: x, top: y);
    }
    dialog = init?.call(dialog) ?? dialog;
    return showWith(dialog, child, width: width, height: height, key: key);
  }

  static WSDialogRiser showWith(WSDialogRiser dialog, Widget child, {double? width, double? height, String? key}) {
    Widget? widget = centralOfRiser?.call(dialog, child: child) ?? child;
    dialog.show(widget, width: width, height: height);
    addToRepo(dialog, key: key);
    /// sync delete
    dialog.addDismissCallBack((d) {
      deleteInRepo(d);
    });
    /// make sure deleted in dispose
    dialog.addDisposeCallBack((d) {
      deleteInRepo(d);
    });
    return dialog;
  }

  // control center for dialog that showed by this wrapper
  static Widget? Function(WSDialogRiser dialog, {Widget? child})? centralOfRiser;

  /// Navigator push and pop
  static WSDialogRiser? getTopNavigatorDialog() {
    WSDialogRiser? riser;
    WSDialogActor.iterateDialogs((dialog) {
      bool isBingo = dialog.isWrappedByNavigator;
      riser = isBingo ? dialog : null;
      return riser != null;
    });
    return riser;
  }

  // if you want to a new navigator then use [pushRoot], if you want to use current navigator then use [push]
  // Use DialogRiser.future.then((result) => ...) to get result
  static WSDialogRiser pushRoot(
    Widget widget, {
    RouteSettings? settings,
    bool? fixed,
    double? x,
    double? y,
    double? width,
    double? height,
    String? key,
  }) {
    return WSDialogActor.show(widget, fixed: fixed, x: x, y: y, width: width, height: height, key: key)
      ..isWrappedByNavigator = true
      ..wrappedNavigatorInitialName = settings?.name;
  }

  // should use 'pushRoot' first or that there is a dialog with 'isWrappedByNavigator = true' on showing
  static Future<T?> push<T extends Object?>(
    Widget widget, {
    PageRouteBuilder<T>? routeBuilder,
    RoutePageBuilder? pageBuilder,
    RouteTransitionsBuilder? transition,

    // copy from PageRouteBuilder constructor
    RouteSettings? settings,
    Duration? duration,
    Duration? reverseDuration,
    bool? opaque,
    bool? barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    bool? maintainState,
    bool? fullscreenDialog,
  }) {
    WSDialogRiser? dialog = getTopNavigatorDialog();
    assert(dialog != null, 'You should ensure already have a navigator-dialog popup, using pushRoot or isWrappedByNavigator = true.');
    return dialog!.push(
      widget,
      duration: duration ?? const Duration(milliseconds: 200),
      reverseDuration: reverseDuration ?? const Duration(milliseconds: 200),
      transition: transition ?? RiserTransitionBuilder.slideFromRight,
      routeBuilder: routeBuilder,
      pageBuilder: pageBuilder,
      settings: settings,
      opaque: opaque,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static void pop<T>({T? result}) {
    getTopNavigatorDialog()?.pop<T>(result: result);
  }

  static void popOrDismiss<T>({T? result}) {
    WSDialogRiser? dialog = WSDialogActor.getTopDialog();
    if (dialog?.isWrappedByNavigator ?? false) {
      if (getTopNavigatorDialog()?.getNavigator()?.canPop() ?? false) {
        pop<T>(result: result);
        return;
      }
    }
    WSDialogActor.dismissDialog(dialog, result: result);
  }

  /// Appearing dialogs management
  static List<WSDialogRiser>? appearingDialogs;

  static Map<String, WSDialogRiser>? appearingDialogsMappings;

  static List<WSDialogRiser> _list() {
    return (appearingDialogs = appearingDialogs ?? []);
  }

  static Map<String, WSDialogRiser> _map() {
    return (appearingDialogsMappings = appearingDialogsMappings ?? {});
  }

  static WSDialogRiser? getTopDialog() {
    return _list().isNotEmpty ? _list().last : null;
  }

  static WSDialogRiser? getDialogByIndex(int reverseIndex) {
    int index = (_list().length - 1) - reverseIndex; // reverse index
    return index >= 0 && index < _list().length ? _list()[index] : null;
  }

  static WSDialogRiser? getDialogByKey(String key) {
    return _map()[key];
  }

  static void iterateDialogs(bool Function(WSDialogRiser dialog) handler) {
    List<WSDialogRiser> list = _list();
    for (int i = list.length - 1; i >= 0; i--) {
      if (handler(list.elementAt(i))) {
        break;
      }
    }
  }

  // dialog management: add/remove/iterate in ordinal
  static void deleteInRepo(WSDialogRiser? dialog) {
    _list().remove(dialog);
    _map().removeWhere((key, value) => value == dialog);
  }

  static void addToRepo(WSDialogRiser dialog, {String? key}) {
    if (key != null) {
      _map()[key] = dialog;
    }
    _list().add(dialog);
  }

  // dismiss methods
  static Future<void> dismissAppearingDialogs() async {
    List<WSDialogRiser> tmp = [..._list()];
    _list().clear();
    _map().clear();

    for (int i = tmp.length - 1; i >= 0; i--) {
      var dialog = tmp[i];
      await _dismiss(dialog);
    }
  }

  static Future<void> dismissTopDialog({int? count}) async {
    if (count != null && count > 0) {
      for (int i = 0; i < count; i++) {
        await dismissDialog(_list().isNotEmpty ? _list().last : null);
      }
      return;
    }
    await dismissDialog(_list().isNotEmpty ? _list().last : null);
  }

  static Future<void> dismissDialog<T extends Object?>(WSDialogRiser? dialog, {String? key, T? result}) async {
    // dismiss from top to bottom if dialog in list
    Future<void> deleteWithDismiss(WSDialogRiser dialog) async {
      List<WSDialogRiser> tmp = [..._list()];
      for (int i = tmp.length - 1; i >= 0; i--) {
        WSDialogRiser d = tmp.elementAt(i);
        deleteInRepo(d);
        await _dismiss<T>(d, result: result);
        if (d == dialog) {
          break;
        }
      }
    }

    if (dialog != null && (_list().contains(dialog))) {
      await deleteWithDismiss(dialog);
    }
    if (key != null && (dialog = _map()[key]) != null) {
      await deleteWithDismiss(dialog!);
    }
  }

  // important!!! do not use this method independently unless you take management of your own dialog
  static Future<void> _dismiss<T extends Object?>(WSDialogRiser? dialog, {T? result}) async {
    if (dialog != null) {
      await dialog.dismiss<T>(result);
    }
  }
}
