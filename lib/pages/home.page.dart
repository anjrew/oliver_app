import 'package:flutter/material.dart';
import 'package:oliver/models/dragable.model.dart';
import 'package:oliver/pages/race.page.dart';
import 'package:oliver/values/image_paths.dart';
import 'package:oliver/widgets/color_target.widget.dart';
import 'package:oliver/widgets/dragable_kid.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _counter = 0;
  String targetString = "Gimme";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.red,
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildAnimatedContainer(context),
                Text(
                  'Oliver pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
								
              ],
            ),
          ),
					ColorChoiceTarget(),
          buildPositionedDragable(),
          buildPositionedDragable(top: 20, left: 300, choice: ColorChoice(Colors.blue, "Blue as the sea!")),
          buildPositionedDragable(top: 500, left:200, choice: ColorChoice(Colors.purple, "Purple like the Ribena!")),
          buildPositionedDragable(top: 300, left: 50, choice: ColorChoice(Colors.orange, "Orange like carrots!")),

          DragableKid(image: oliverImage, x: 10, y: 10),
          DragableKid(image: freddieImage, x: 100, y: 200),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Positioned buildPositionedDragable({ColorChoice choice, double top, double left}) {
    ColorChoice secondChoice = choice == null ? new ColorChoice(Colors.yellow, "Yellow go!") : null;
    return Positioned(
      top: top ?? 100,
      left: left ?? 100,
      child: Draggable<ColorChoice>(
        data: choice ?? secondChoice,
        child: dragable(choice ?? secondChoice),
        feedback: dragable(choice ?? secondChoice),
        childWhenDragging: Container(),
        onDraggableCanceled: (v, o) =>
            _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Try again!"),
        )),
      ),
    );
  }

  AnimatedContainer buildAnimatedContainer(BuildContext context) {
    return AnimatedContainer(
      height: _counter > 20 ? 200 : 0,
      width: _counter > 20 ? 200 : 0,
      child: Text(
        _counter > 40 ? "OK stop it oliver!" : "You Win",
        style: Theme.of(context).textTheme.display2,
      ),
      duration: Duration(seconds: 1),
    );
  }

  
  Widget dragable(ColorChoice color, {bool big = false, bool showText = false}) =>
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: big ? 100 : 30,
        width: big ? 100 : 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color.color,
        ),
        child: Center(
          child: Text(
            showText ? color.text ?? '' : '',
            textAlign: TextAlign.center,
          ),
        ),
      );

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: _reset,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.directions_car),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RacePage())),)
      ],
      title: Text(widget.title),
    );
  }

  void _reset() => setState(() { 
    this._counter = 0; 
    });
}
