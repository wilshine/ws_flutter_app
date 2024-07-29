import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WsExampleFlutterSpinkitView extends StatefulWidget {
  const WsExampleFlutterSpinkitView({super.key});

  @override
  State<WsExampleFlutterSpinkitView> createState() => _WsExampleFlutterSpinkitViewState();
}

class _WsExampleFlutterSpinkitViewState extends State<WsExampleFlutterSpinkitView> {
  static const kits = <Widget>[
    SpinKitRotatingCircle(
      color: Colors.white,
      size: 30,
    ),
    SpinKitRotatingPlain(
      color: Colors.white,
      size: 30,
    ),
    SpinKitChasingDots(
      color: Colors.white,
      size: 30,
    ),
    SpinKitPumpingHeart(
      color: Colors.white,
      size: 30,
    ),
    SpinKitPulse(
      color: Colors.white,
      size: 30,
    ),
    SpinKitDoubleBounce(
      color: Colors.white,
      size: 30,
    ),
    SpinKitWave(
      color: Colors.white,
      type: SpinKitWaveType.start,
      size: 30,
    ),
    SpinKitWave(
      color: Colors.white,
      type: SpinKitWaveType.center,
      size: 30,
    ),
    SpinKitWave(
      color: Colors.white,
      type: SpinKitWaveType.end,
      size: 30,
    ),
    SpinKitPianoWave(
      color: Colors.white,
      type: SpinKitPianoWaveType.start,
      size: 30,
    ),
    SpinKitPianoWave(
      color: Colors.white,
      type: SpinKitPianoWaveType.center,
      size: 30,
    ),
    SpinKitPianoWave(
      color: Colors.white,
      type: SpinKitPianoWaveType.end,
      size: 30,
    ),
    SpinKitThreeBounce(
      color: Colors.white,
      size: 30,
    ),
    SpinKitThreeInOut(color: Colors.white),
    SpinKitWanderingCubes(
      color: Colors.white,
      size: 30,
    ),
    SpinKitWanderingCubes(
      color: Colors.white,
      shape: BoxShape.circle,
      size: 30,
    ),
    SpinKitCircle(
      color: Colors.white,
      size: 30,
    ),
    SpinKitFadingFour(
      color: Colors.white,
      size: 30,
    ),
    SpinKitFadingFour(
      color: Colors.white,
      shape: BoxShape.rectangle,
      size: 30,
    ),
    SpinKitFadingCube(
      color: Colors.white,
      size: 30,
    ),
    SpinKitCubeGrid(
      size: 30.0,
      color: Colors.white,
    ),
    SpinKitFoldingCube(
      color: Colors.white,
      size: 30,
    ),
    SpinKitRing(
      color: Colors.white,
      size: 30,
    ),
    SpinKitDualRing(
      color: Colors.white,
      size: 30,
    ),
    SpinKitSpinningLines(
      color: Colors.white,
      size: 30,
    ),
    SpinKitFadingGrid(
      color: Colors.white,
      size: 30,
    ),
    SpinKitFadingGrid(
      color: Colors.white,
      shape: BoxShape.rectangle,
      size: 30,
    ),
    SpinKitSquareCircle(
      color: Colors.white,
      size: 30,
    ),
    SpinKitSpinningCircle(
      color: Colors.white,
      size: 30,
    ),
    SpinKitSpinningCircle(
      color: Colors.white,
      shape: BoxShape.rectangle,
      size: 30,
    ),
    SpinKitFadingCircle(
      color: Colors.white,
      size: 30,
    ),
    SpinKitPulsingGrid(
      color: Colors.white,
      size: 30,
    ),
    SpinKitPulsingGrid(
      color: Colors.white,
      boxShape: BoxShape.rectangle,
      size: 30,
    ),
    SpinKitHourGlass(
      color: Colors.white,
      size: 30,
    ),
    SpinKitPouringHourGlass(
      color: Colors.white,
      size: 30,
    ),
    SpinKitPouringHourGlassRefined(
      color: Colors.white,
      size: 30,
    ),
    SpinKitRipple(
      color: Colors.red,
      size: 30,
    ),
    SpinKitDancingSquare(
      color: Colors.white,
      size: 30,
    ),
    SpinKitWaveSpinner(
      color: Colors.white,
      size: 30,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('SpinKit', style: TextStyle(fontSize: 24.0)),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.adaptiveCrossAxisCount,
          mainAxisSpacing: 46,
          childAspectRatio: 2,
        ),
        padding: const EdgeInsets.only(top: 32, bottom: 64),
        itemCount: kits.length,
        itemBuilder: (context, index) => Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: kits[index],
              bottom: 20,
              left: 0,
              right: 0,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${kits[index]}',
                  style: const TextStyle(fontSize: 11, color: Colors.white),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension on BuildContext {
  int get adaptiveCrossAxisCount {
    final width = MediaQuery.of(this).size.width;
    if (width > 1024) {
      return 8;
    } else if (width > 720 && width < 1024) {
      return 6;
    } else if (width > 480) {
      return 4;
    } else if (width > 320) {
      return 3;
    }
    return 1;
  }
}
