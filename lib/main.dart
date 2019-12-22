import 'package:flutter/material.dart';
import 'package:oliver/pages/home.page.dart';
import 'package:oliver/widgets/dragable_kid.dart';
import 'models/dragable.model.dart';

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
      home: MyHomePage(title: 'YO OLIVER!'),
    );
  }
}



