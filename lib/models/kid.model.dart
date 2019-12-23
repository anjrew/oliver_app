import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oliver/pages/race.page.dart';

class KidData {
	HandSide side;
	int score = 0;
	String name;
  Function move;
  String imagePath;
  double position;
	double size;
	IconData vehicle;

  KidData(
      {@required this.position, @required this.move, @required this.imagePath, @required this.name, this.size = 50, @required this.side, this.vehicle = Icons.directions_car});
}
