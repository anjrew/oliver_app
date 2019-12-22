import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oliver/models/kid.model.dart';
import 'package:oliver/values/image_paths.dart' as image;

class RacePage extends StatefulWidget {
  @override
  _RacePageState createState() => _RacePageState();
}

class _RacePageState extends State<RacePage> {
  double kidSize = 40;

  KidData oliver;
  KidData freddie;
  double finishLine;
  final double startingPosition = 10;

  @override
  void initState() {
    startRace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    finishLine = MediaQuery.of(context).size.height * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text("Grand Prix"),
        leading: BackButton(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() => startRace()),
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildTrack(oliver),
            buildTrack(freddie),
          ],
        ),
        Positioned(
          top: finishLine,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Card(
              color: Colors.grey,
              child: Center(
                child: Text("Finish Line"),
              ),
            ),
          ),
        ),
        buildScoreCounter(context, kid: oliver),
        buildScoreCounter(context, kid: freddie),
        buildMoveButton(position: HandSide.left, onPressed: oliver.move),
        buildMoveButton(position: HandSide.right, onPressed: freddie.move),
      ]),
    );
  }

  Positioned buildScoreCounter(
    BuildContext context, {
    @required KidData kid,
  }) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 3,
      left: kid.side == HandSide.left ? 20 : null,
      right: kid.side == HandSide.right ? 20 : null,
      child: Column(
        children: <Widget>[
          Container(
            width: 50,
            child: Text(
              "${kid.name} Score",
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            "${kid.score}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.display1,
          ),
        ],
      ),
    );
  }

  void startRace() {
    oliver = new KidData(
        side: HandSide.left,
        name: 'Oliver',
        move: () => moveKid(oliver),
        imagePath: image.oliverImage,
        position: 20);
    freddie = new KidData(
        side: HandSide.right,
        name: 'Freddie',
        move: () => moveKid(freddie),
        imagePath: image.freddieImage,
        position: 20);
  }

  Future<void> moveKid(KidData kid) async {
    if (kid.position > finishLine) {
      await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => Center(
          child: CupertinoActionSheet(
            title: Text(
              "${kid.name} WINS!",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                isDestructiveAction: false,
                child: Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
      setState(() {
        kid.score++;
        oliver.position = startingPosition;
        freddie.position = startingPosition;
      });
    } else {
      setState(() => kid.position += 10);
    }
  }
}

Positioned buildMoveButton({HandSide position, void Function() onPressed}) {
  return Positioned(
    bottom: 20,
    left: position == HandSide.left ? 20 : null,
    right: position == HandSide.right ? 20 : null,
    child: RawMaterialButton(
      hoverColor: Colors.amber,
      fillColor: Colors.purple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Icon(Icons.arrow_upward),
      onPressed: onPressed,
    ),
  );
}

Widget buildTrack(KidData kidData) {
  return Stack(
    alignment: AlignmentDirectional.topCenter,
    children: [
      Container(
        width: 50,
        height: double.infinity,
        color: Colors.amber,
      ),
      AnimatedPositioned(
        duration: Duration(milliseconds: 80),
        top: kidData.position,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          height: kidData.size,
          width: kidData.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kidData.size / 2),
          ),
          child: ClipOval(
              // borderRadius: BorderRadius.circular(kidData.size / 2),
              child: Hero(
                key: Key(kidData.imagePath),
                tag: kidData.imagePath,
                child: Image.asset(
                  kidData.imagePath,
                  fit: BoxFit.cover,
                ),
              )),
        ),
      ),
    ],
  );
}

enum HandSide { left, right }
