import 'package:flutter/cupertino.dart';

class CustomScrollPhysics extends ScrollPhysics {
  final double scrollSpeed;

  CustomScrollPhysics({this.scrollSpeed = 1.0, ScrollPhysics? parent})
      : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
      scrollSpeed: scrollSpeed,
      parent: buildParent(ancestor),
    );
  }

  @override
  double get friction => 0.1 * scrollSpeed;

  @override
  double get dragStartDistanceMotionThreshold => 4.0 * scrollSpeed;
}
