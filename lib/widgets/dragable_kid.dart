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

class _DragableKidState extends State<DragableKid>
    with SingleTickerProviderStateMixin {
  Offset position;
  double size = 100;
  double angle = 0;
  AnimationController rotationController;

  @override
  void initState() {
    this.position = widget.position;
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy - 50,
      left: position.dx,
      child: Draggable<Image>(
        child: kidContainer(widget.image),
        feedback: kidContainer(widget.image),
        childWhenDragging: Container(),
        onDragEnd: (DraggableDetails details) {
          setState(() {
            this.position = details.offset;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  GestureDetector kidContainer(String imagePath) {
    return GestureDetector(
      onDoubleTap: () => setState(() => size = size * 1.5),
      onLongPress: () => rotationController.repeat(),
      onLongPressEnd: (LongPressEndDetails details) =>
          rotationController.stop(),
      onTap: () => setState(() => size = size / 1.5),
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: ClipOval(
              // borderRadius: BorderRadius.circular(size / 2),
              child: Hero(
                key: Key(imagePath),
                tag: imagePath,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              )),
        ),
      ),
    );
  }
}
