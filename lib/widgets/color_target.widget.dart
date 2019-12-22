import 'package:flutter/material.dart';
import 'package:oliver/models/dragable.model.dart';
import 'package:oliver/values/durations.dart' as dur;

class ColorChoiceTarget extends StatefulWidget {
  @override
  _ColorChoiceTargetState createState() => _ColorChoiceTargetState();
}

class _ColorChoiceTargetState extends State<ColorChoiceTarget>
    with SingleTickerProviderStateMixin {
  Color color = Colors.green;
  String text = "Drop a color on me";
  AnimationController sizeAnimation;

  @override
  void initState() {
    sizeAnimation = new AnimationController(
        lowerBound: 100,
        upperBound: 110,
        vsync: this,
        duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50,
      bottom: 50,
      child: DragTarget<ColorChoice>(
        onAccept: (ColorChoice coice) {
					sizeAnimation.stop();
					Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "You DID IT!",
              style: TextStyle(color: Colors.green),
            ),
            duration: dur.snackBarDuration,
          ),
        );
				},
        onWillAccept: (ColorChoice coice) {
          sizeAnimation.repeat();
          return true;
        },
				onLeave: (_) => sizeAnimation.stop(),
        builder: (BuildContext context, List<ColorChoice> candidateData,
            List rejectedData) {
          if (candidateData != null) {
            if (candidateData.length > 0) {
              text = candidateData[0].text;
              color = candidateData[0].color;
            }
          }
          return AnimatedBuilder(
            animation: sizeAnimation,
            child: Center(
              child: Text(
                text ?? '',
                textAlign: TextAlign.center,
              ),
            ),
            builder: (BuildContext context, Widget child) => Container(
							padding: EdgeInsets.all(20),
              height: sizeAnimation.value,
              width: sizeAnimation.value,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sizeAnimation.value / 2),
                color: color,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
