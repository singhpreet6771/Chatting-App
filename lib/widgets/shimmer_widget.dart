import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    this.width = double.infinity,
    @required this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
});

  const ShimmerWidget.circular({
    @required this.width,
    @required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  const ShimmerWidget.icon({
    @required this.width,
    @required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350],
      highlightColor: Colors.grey[100],
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
            color: Colors.grey[350],
            shape: shapeBorder
        ),
      ),
    );
  }
}
