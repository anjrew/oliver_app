import 'package:flutter/material.dart';

class DragableKid extends StatefulWidget {
  final Offset position;
  final String image;

  DragableKid({@required this.image, @required double x, @required double y})
      : this.position = new Offset(x, y) {
    assert(position != null,
        "The position should have a value on init for Dragable kid");
  }

  @override
  _DragableKidState createState() => _DragableKidState();
}

class _DragableKidState extends State<DragableKid> {
  Offset position;
	double size = 100;

  @override
  void initState() {
    this.position = widget.position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy - size,
      left: position.dx,
      child: Draggable<Image>(
        child: kidContainer(widget.image),
        feedback: kidContainer(widget.image),
        childWhenDragging: Container(),
				onDragEnd: (DraggableDetails details){
					setState(() {
						this.position = details.offset;
					});
				},
      ),
    );
  }

  Container kidContainer(String imagePath) {
    return Container(
			height: size,
			width: size,
      decoration: BoxDecoration(
				color: Colors.amber,
				borderRadius: BorderRadius.circular(50),
				),
      child: Image.asset(imagePath),
    );
  }
}
