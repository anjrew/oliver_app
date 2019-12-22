import 'package:flutter/foundation.dart';
import 'package:oliver/pages/race.page.dart';

class KidData {
	HandSide side;
	int score = 0;
	String name;
  Function move;
  String imagePath;
  double position;
	double size;

  KidData(
      {@required this.position, @required this.move, @required this.imagePath, @required this.name, this.size = 50, @required this.side});
}
