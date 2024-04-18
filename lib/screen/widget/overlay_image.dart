import 'package:flutter/material.dart';
import 'package:paint_app/public/gesture.dart';

class OverlayImage extends StatelessWidget {
  final Widget child;
  final Function(Offset) onScaleStart;
  final Function(Key?) onScaleEnd;

  const OverlayImage({
    Key? key,
    required this.child,
    required this.onScaleEnd,
    required this.onScaleStart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return MatrixGestureDetector(
      key: key,
      onMatrixUpdate: (matrix, translationDeltaMatrix, scaleDeltaMatrix,
          rotationDeltaMatrix) {
        notifier.value = matrix;
      },
      onScaleStart: onScaleStart,
      onScaleEnd: onScaleEnd,
      child: AnimatedBuilder(
        animation: notifier,
        builder: (context, childAni) {
          return Transform(
            transform: notifier.value,
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.cover,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
