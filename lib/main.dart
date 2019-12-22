import 'package:flutter/material.dart';
import 'package:oliver/dragable_kid.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'YO OLIVER'),
    );
  }
}

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
  String text = '';

  Offset oliverPosition = Offset(100, 100);
  Offset freddiePosition = Offset(100, 100);


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
      appBar: buildAppBar(dragable(Colors.blue)),
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
          buildDragTarget(),
          buildPositionedDragable(),
          DragableKid(image: 'assets/images/Oliver.png', x: 10, y:10),
          DragableKid(image: 'assets/images/Freddie.png', x: 100, y:200),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Positioned buildPositionedDragable() {
    return Positioned(
      top: 100,
      right: 100,
      child: Draggable<String>(
        data: "Yellow is the best",
        child: dragable(Colors.yellow),
        feedback: dragable(Colors.yellow),
        childWhenDragging: Container(),
        onDraggableCanceled: (v, o) =>
            _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("MOre more"),
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
      duration: Duration(seconds: 2),
    );
  }

  Positioned buildDragTarget() {
    return Positioned(
      left: 50,
      bottom: 50,
      child: DragTarget<String>(
        onLeave: (String number) => _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Don't leave me"),
          ),
        ),
        onAccept: (String number) => _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "You DID IT!",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
        onWillAccept: (String number) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                "Cool Drop me here!",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          );
          return true;
        },
        builder: (BuildContext context, List candidateData, List rejectedData) {
          if (candidateData != null) {
            if (candidateData.length > 0) {
              text = candidateData[0];
            }
          }
          return dragable(Colors.green, big: true, text: text);
        },
      ),
    );
  }

  Widget dragable(Color color, {bool big = false, String text = ''}) =>
      Container(
        height: big ? 100 : 30,
        width: big ? 100 : 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Center(
          child: Text(text ?? '', textAlign: TextAlign.center,),
        ),
      );

  AppBar buildAppBar(Widget dragable) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () => setState(() => this._counter = 0),
      ),
      actions: <Widget>[
        Draggable<String>(
          data: "Blue rocks",
          child: dragable,
          feedback: dragable,
          childWhenDragging: Container(),
          onDragCompleted: () => print("Drag completed"),
          onDragEnd: (_) => print("Drag Eneded"),
          onDragStarted: () => print("Drag started"),
          onDraggableCanceled: (v, o) =>
              _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("MOre more"),
          )),
        ),
      ],
      title: Text(widget.title),
    );
  }
}
