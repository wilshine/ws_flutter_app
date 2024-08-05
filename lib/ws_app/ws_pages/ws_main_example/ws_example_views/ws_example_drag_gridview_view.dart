import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final List<IconData> icons = [
  Icons.abc,
  Icons.back_hand,
  Icons.cabin,
  Icons.dangerous,
  Icons.earbuds,
  Icons.face,
  Icons.gamepad,
  Icons.h_plus_mobiledata,
  // Icons.image,
];

/// https://medium.com/@dengpan9610.wang/flutter-build-a-draggable-grid-view-using-gesture-recognizers-a6a94ed67cce
class GridGalleryExample extends StatefulWidget {
  const GridGalleryExample({Key? key}) : super(key: key);

  @override
  State<GridGalleryExample> createState() => _GridGalleryExampleState();
}

class _GridGalleryExampleState extends State<GridGalleryExample> {
  final List<Widget> galleries = List.generate(
    icons.length,
    (index) => IconButton(
      onPressed: () {
        print('click>>>>>>$index');
      },
      icon: Icon(icons[index]),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grid Gallery Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: DecoratedBox(
            decoration: BoxDecoration(border: Border.all()),
            child: GridGallery(galleries: galleries),
          ),
        ),
      ),
    );
  }
}

typedef GalleryItemBuilder = Widget Function();

class GridGallery extends StatefulWidget {
  final int crossAxisCount;
  final List<Widget> galleries;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final int? maxCount;
  final Axis scrollDirection;
  final Curve curve;
  final GalleryItemBuilder? addGallery;

  const GridGallery({
    Key? key,
    required this.galleries,
    this.scrollDirection = Axis.vertical,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 5.0,
    this.mainAxisSpacing = 5.0,
    this.maxCount,
    this.curve = Curves.easeIn,
    this.addGallery,
  }) : super(key: key);

  @override
  State<GridGallery> createState() => GridGalleryState();

  static GridGalleryState of(BuildContext context) {
    final state = context.findAncestorStateOfType<GridGalleryState>();

    assert(state != null, "No [GridGalleryState] found.");
    return state!;
  }

  static GridGalleryState? mayOf(BuildContext context) {
    final state = context.findAncestorStateOfType<GridGalleryState>();
    return state!;
  }
}

class GridGalleryState extends State<GridGallery> with TickerProviderStateMixin, GalleryGridDragDelegate {
  final Map<int, GalleryItemWidgetState> _items = {};

  @override
  Map<int, GalleryItemWidgetState> get items => _items;

  @override
  List<Widget> get galleries => widget.galleries;

  bool get canAddGallery =>
      widget.addGallery != null && (widget.maxCount == null || galleries.length < widget.maxCount!);

  @override
  Widget build(BuildContext context) {
    return GridView(
      scrollDirection: widget.scrollDirection,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      children: [
        for (int i = 0; i < widget.galleries.length; i++)
          GalleryItemWidget(
            key: ValueKey(i),
            index: i,
            curve: widget.curve,
            child: widget.galleries[i],
          ),
        if (canAddGallery) widget.addGallery!.call(),
      ],
    );
  }

  /// register [item] so as to it could be translated by [_translateItems] when
  /// [_onDragUpdate] and also allow [GridGallery] to control its rebuild.
  void registerItem(GalleryItemWidgetState item) {
    _items[item.index] = item;

    if (item.index == _drag?.index) {
      item.isDragging = true;
      item.rebuild();
    }
  }

  /// only unregister the item if the [index] is matched to [item]
  void unregisterItem(int index, GalleryItemWidgetState item) {
    final current = _items[index];

    if (current == item) {
      _items.remove(index);
    }
  }

  ///
  /// origin------x
  /// |
  /// |
  /// y
  Offset calculateItemCoordinate(int itemIndex) {
    final vertical = (itemIndex ~/ widget.crossAxisCount).toDouble();
    final horizontal = (itemIndex % widget.crossAxisCount).toDouble();

    switch (widget.scrollDirection) {
      case Axis.vertical:
        return Offset(horizontal, vertical);
      case Axis.horizontal:
        return Offset(vertical, horizontal);
    }
  }

  /// [GalleryItemDragStartListener] will call this to register [_drag]
  /// and thus response to [_onDragUpdate] after [MultiDragGestureRecognizer.onStart]
  void startItemDragging({
    required int index,
    required PointerDownEvent event,
    required MultiDragGestureRecognizer recognizer,
  }) {
    assert(index >= 0 && index < widget.galleries.length);

    _cleanDragIfNecessary(event);

    if (_items.containsKey(index)) {
      _dragIndex = index;
      _recognizer = recognizer
        ..onStart = _startDrag
        ..addPointer(event);
    } else {
      throw Exception('Attempting to start a drag on a non-visible item: $index');
    }
  }
}

mixin GalleryGridDragDelegate<T extends StatefulWidget> on State<T>, TickerProvider {
  Map<int, GalleryItemWidgetState> get items;

  List<Widget> get galleries;

  /// [_recognizer] used to detect the drag gesture and trigger [_startDrag] when [MultiDragGestureRecognizer.onStart]
  MultiDragGestureRecognizer? _recognizer;

  /// [_draggingOverlay] used to display the dragging [GalleryItem]
  OverlayEntry? _draggingOverlay;

  /// [_drag] used to track the last drag operation
  /// also responsible for listening to [_onDragUpdate], [_onDragCompleted]
  /// [_onDragCancel] and [_onDragEnd]
  GalleryItemDrag? _drag;

  /// the index of the item dragging
  /// it would be reset after [_onDragCompleted]
  int? _dragIndex;

  /// the index that the dragging item will be inserted into after [_onDragCompleted] and [_onDragUpdate]
  /// eventually swap the [_dragIndex] and [_targetIndex] after [_onDragCompleted]
  int? _targetIndex;

  /// 1) register [_drag] to handle [_onDragCancel], [_onDragUpdate] and [_onDragEnd]
  /// 2) also build [_draggingOverlay] to display the dragging item
  /// 3) notify items the drag is starting by [GalleryItemWidgetState.updateDrag]
  Drag? _startDrag(Offset position) {
    assert(_drag == null);

    final item = items[_dragIndex]!;

    item.isDragging = true;
    item.rebuild();

    _targetIndex = item.index;

    _drag = GalleryItemDrag(
      item: item,
      initialPosition: position,
      onDragCancel: _onDragCancel,
      onDragEnd: _onDragEnd,
      onDragUpdate: _onDragUpdate,
    );

    _draggingOverlay = OverlayEntry(builder: _drag!.buildOverlay);
    Overlay.of(context).insert(_draggingOverlay!);

    return _drag;
  }

  /// when the [_drag] updates the [GalleryItemDrag.dragPosition]
  /// [_draggingOverlay] must be moved the new position
  /// [_items] should also be translated temporarily before [_onDragCompleted]
  void _onDragUpdate(GalleryItemDrag drag, Offset position, Offset delta) {
    _draggingOverlay?.markNeedsBuild();
    _translateItems(delta);
    setState(() {});
  }

  // TODO: allow more callbacks
  void _onDragEnd(GalleryItemDrag drag) {
    _onDragCompleted();
  }

  void _onDragCancel(GalleryItemDrag drag) {
    _resetDrag();
  }

  /// before the drag is completed, all items are translated temporarily
  /// once the drag is completed, items finally are swapped
  void _onDragCompleted() {
    final int fromIndex = _dragIndex!;
    final int toIndex = _targetIndex!;

    print('drag completed: $fromIndex -> $toIndex ');

    final gallery = galleries.removeAt(fromIndex);

    galleries.insert(toIndex, gallery);

    _resetDrag();
  }

  /// clean the previous drag operation
  void _cleanDragIfNecessary(PointerDownEvent event) {
    if (_drag != null) {
      // cancel the previous drag
      _resetDrag();
    } else if (_recognizer != null) {
      // reset the previous recognizer
      _recognizer?.dispose();
      _recognizer = null;
    }
  }

  /// no matter [_drag] is completed or canceled
  /// all resources are used to listen and handle drag details should be restore
  /// particularly, we must [_resetItemTranslation] to clean the temporary information during dragging
  /// and prepare them for subsequent drag operations
  /// otherwise, the items may not be translated correctly during subsequent dragging
  /// due to the wrong [GalleryItemWidgetState.offset]
  /// and unmatched index between [GalleryItemWidgetState.index] and [GalleryItemWidgetState.movingIndex]
  void _resetDrag() {
    if (_drag != null) {
      if (_dragIndex != null && items.containsKey(_dragIndex)) {
        final item = items[_dragIndex]!;
        item.rebuild();
        _dragIndex = null;
      }

      _drag = null;
      _recognizer?.dispose();
      _resetItemTranslation();
      _recognizer = null;
      _draggingOverlay?.remove();
      _draggingOverlay = null;
      _targetIndex = null;
    }

    setState(() {});
  }

  /// for each drag update, we detect whose [Rect] contains the drag position
  /// and set [_targetIndex] as [GalleryItemWidget.index]
  /// then we will calculate the effective index for each item
  /// 1) if [_dragIndex] is less than [_targetIndex],
  /// all items whose index is between (_dragIndex, _targetIndex] should be forwarded by index -1,
  /// while others should be restored to their original index wherever they are translated before previous drag updates
  ///
  /// 2) if [_dragIndex] is greater than [_targetIndex]
  /// all items whose index is between  [_targetIndex, _dragIndex) should be backward by index + 1, while
  /// other items will be restored
  void _translateItems(Offset delta) {
    assert(_drag != null);

    final Size gapSize = _drag!.itemSize;
    final Offset pointer = _drag!.overlayPosition(context);
    final Offset dragPosition = pointer + _drag!.itemSize.center(Offset.zero);

    int newTargetIndex = _targetIndex!;

    // print('----------pointer: $pointer, center: $dragPosition');
    // find the item containing the the drag position as the drop target
    for (final item in items.values) {
      // if (item.index == _dragIndex ||
      //     !item.mounted ||
      //     !item.isTransitionCompleted) continue;
      if (!item.mounted || !item.isTransitionCompleted) continue;

      final Rect geometry = Rect.fromCenter(
        center: item.geometry.center,
        width: item.size!.width * 0.5,
        height: item.size!.height * 0.5,
      );

      if (geometry.contains(dragPosition)) {
        newTargetIndex = item.index;
        break;
      }
    }

    assert(_dragIndex != null && _targetIndex != null);
    // update drag info for each if the drop target is not the dragging item
    if (newTargetIndex != _targetIndex) {
      final bool forward = _dragIndex! < newTargetIndex;
      _targetIndex = newTargetIndex;

      print('backward => $forward, dragging: $_dragIndex, target: $newTargetIndex');

      for (final item in items.values) {
        // TODO: if the item at the target index is not the drag index, should also apply new index
        if (item.index == _dragIndex!) {
          item.apply(moving: _targetIndex!, gapSize: gapSize);
          continue;
        }

        if (forward) {
          if (item.index > _dragIndex! && item.index <= _targetIndex!) {
            item.apply(moving: item.index - 1, gapSize: gapSize);
          } else {
            item.apply(moving: item.index, gapSize: gapSize);
          }
        } else {
          if (item.index >= _targetIndex! && item.index < _dragIndex!) {
            item.apply(moving: item.index + 1, gapSize: gapSize);
          } else {
            item.apply(moving: item.index, gapSize: gapSize);
          }
        }
      }
    }
  }

  void _resetItemTranslation() {
    for (final item in items.values) {
      item.reset();
    }
  }
}

///////

typedef GalleryItemDragUpdate = void Function(GalleryItemDrag, Offset, Offset);
typedef GalleryItemDragCallback = void Function(GalleryItemDrag);

Offset _overlayOrigin(BuildContext context) {
  final OverlayState overlay = Overlay.of(context);
  final RenderBox overlayBox = overlay.context.findRenderObject()! as RenderBox;
  return overlayBox.localToGlobal(Offset.zero);
}

class GalleryItemDrag extends Drag {
  late GridGalleryState gridState;
  late int index;
  late Widget child;
  late Offset dragPosition;
  late Offset dragOffset;
  late Size itemSize;

  final GalleryItemDragUpdate? onDragUpdate;
  final GalleryItemDragCallback? onDragEnd;
  final GalleryItemDragCallback? onDragCancel;

  GalleryItemDrag({
    required GalleryItemWidgetState item,
    Offset initialPosition = Offset.zero,
    this.onDragUpdate,
    this.onDragCancel,
    this.onDragEnd,
  }) {
    final itemBox = item.context.findRenderObject()! as RenderBox;

    gridState = item.gridState;
    index = item.index;
    child = item.widget.child;
    dragPosition = initialPosition;
    dragOffset = itemBox.globalToLocal(initialPosition);
    itemSize = itemBox.size;
  }

  @override
  void update(DragUpdateDetails details) {
    final Offset delta = details.delta;

    dragPosition += delta;
    onDragUpdate?.call(this, dragPosition, details.delta);
  }

  @override
  void end(DragEndDetails details) {
    onDragEnd?.call(this);
  }

  @override
  void cancel() {
    onDragCancel?.call(this);
  }

  /// get the top-left position of the dragging item
  Offset overlayPosition(BuildContext context) {
    return dragPosition - dragOffset - _overlayOrigin(context);
  }

  Widget buildOverlay(BuildContext context) {
    return DraggingItemOverlay(
      gridState: gridState,
      index: index,
      position: overlayPosition(context),
      size: itemSize,
      child: child,
    );
  }
}

class DraggingItemOverlay extends StatelessWidget {
  final GridGalleryState gridState;
  final int index;
  final Widget child;
  final Offset position;
  final Size size;

  const DraggingItemOverlay({
    Key? key,
    required this.gridState,
    required this.child,
    required this.index,
    required this.position,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Material(
        elevation: 4.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
          ),
          child: SizedBox.fromSize(
            size: size,
            child: child,
          ),
        ),
      ),
    );
  }
}

///////////

class GalleryItemWidget extends StatefulWidget {
  final int index;
  final Widget child;
  final Curve curve;

  const GalleryItemWidget({
    Key? key,
    required this.child,
    required this.index,
    this.curve = Curves.easeIn,
  }) : super(key: key);

  @override
  State<GalleryItemWidget> createState() => GalleryItemWidgetState();
}

class GalleryItemWidgetState extends State<GalleryItemWidget> with GalleryItemDragDelegate {
  AnimationController? _controller;

  ValueKey<int> get key => ValueKey<int>(widget.index);

  @override
  int get index => widget.index;

  @override
  Curve get curve => widget.curve;

  @override
  AnimationController? get animation => _controller;

  @override
  set animation(AnimationController? value) => _controller = value;

  bool get isTransitionCompleted => _controller == null || _controller!.status == AnimationStatus.completed;

  @override
  void initState() {
    super.initState();

    gridState = GridGallery.of(context);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GalleryItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // print('update: from ${oldWidget.index} to ${widget.index}');

    if (oldWidget.index != widget.index) {
      gridState.unregisterItem(oldWidget.index, this);
      gridState.registerItem(this);
    }
  }

  @override
  void deactivate() {
    gridState.unregisterItem(index, this);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = context.findRenderObject() as RenderBox;

      size = box.size;
    });

    gridState.registerItem(this);

    if (isDragging) {
      return const SizedBox();
    }
    if (offset.dx > 0 || offset.dy > 0) print('item build>>>>>$index >>> $offset');
    return GalleryItemDragStartListener(
      index: index,
      child: Transform.translate(
        offset: offset,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Align(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class GalleryItemDragStartListener extends StatelessWidget {
  final int index;
  final Widget child;
  final bool enabled;

  const GalleryItemDragStartListener({
    Key? key,
    required this.index,
    required this.child,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: enabled ? (event) => _startDragging(context, event) : null,
      child: child,
    );
  }

  MultiDragGestureRecognizer createRecognizer() {
    return ImmediateMultiDragGestureRecognizer(debugOwner: this);
  }



  void _startDragging(BuildContext context, PointerDownEvent event) {
    final DeviceGestureSettings? gestureSetting = MediaQuery.maybeOf(context)?.gestureSettings;

    final GridGalleryState? grid = GridGallery.mayOf(context);

    grid?.startItemDragging(
      index: index,
      event: event,
      recognizer: createRecognizer()..gestureSettings = gestureSetting,
    );
  }
}

mixin GalleryItemDragDelegate<T extends StatefulWidget> on State<T> {
  late GridGalleryState gridState;
  bool isDragging = false;

  Size? size;
  Offset startOffset = Offset.zero;
  Offset targetOffset = Offset.zero;

  int get index;

  Curve get curve;

  AnimationController? get animation;

  set animation(AnimationController? value);

  bool get isTransitionEnd => animation == null;

  Offset get offset {
    if (animation != null) {
      final double t = curve.transform(animation!.value);

      return Offset.lerp(startOffset, targetOffset, t)!;
    }
    return targetOffset;
  }

  /// return the original [RenderBox]'s top-left
  /// the effective geometry should be (itemPosition - targetOffset) & size!
  Rect get geometry {
    final box = context.findRenderObject() as RenderBox;
    final Offset itemPosition = box.localToGlobal(Offset.zero);

    size = box.size;

    return itemPosition & size!;
  }

  Rect get translatedGeometry {
    return geometry.translate(targetOffset.dx, targetOffset.dy);
  }

  void apply({
    required int moving,
    required Size gapSize,
    bool playAnimation = true,
  }) {
    translateTo(moving: moving, gapSize: gapSize);

    if (playAnimation) {
      animate();
    } else {
      jump();
    }
    rebuild();
  }

  /// 计算自己的偏移量
  void translateTo({required int moving, required Size gapSize}) {
    if (index == moving) {
      targetOffset = Offset.zero;
      return;
    }

    final Offset original = gridState.calculateItemCoordinate(index);
    final Offset target = gridState.calculateItemCoordinate(moving);

    final Axis mainAxis = gridState.widget.scrollDirection;

    double verticalSpacing = 0.0;
    double horizontalSpacing = 0.0;

    switch (mainAxis) {
      case Axis.vertical:
        verticalSpacing = gridState.widget.mainAxisSpacing;
        horizontalSpacing = gridState.widget.crossAxisSpacing;
        break;
      case Axis.horizontal:
        verticalSpacing = gridState.widget.crossAxisSpacing;
        horizontalSpacing = gridState.widget.mainAxisSpacing;
        break;
    }

    targetOffset = (target - original).scale(gapSize.width + horizontalSpacing, gapSize.height + verticalSpacing);
    print('index=$index >>>>>>targetOffset=$targetOffset');
  }

  void animate() {
    // print('animate>>>>>>> $animation');
    if (animation == null) {
      animation = AnimationController(
        vsync: gridState,
        duration: const Duration(
          milliseconds: 100,
        ),
      )
        ..addListener(rebuild)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            startOffset = targetOffset;
            animation?.dispose();
            animation = null;
            rebuild();
          }
        })
        ..forward();
    } else {
      startOffset = offset;
      animation?.forward(from: 0);
    }
  }

  void jump() {
    animation?.dispose();
    animation = null;
    startOffset = targetOffset;
    // rebuild();
  }

  void rebuild() {
    setState(() {});
  }

  void reset() {
    animation?.dispose();
    animation = null;
    startOffset = Offset.zero;
    targetOffset = Offset.zero;
    isDragging = false;
    rebuild();
  }
}
