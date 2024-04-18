import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/bloc/paint_bloc.dart';
import 'package:paint_app/public/gesture.dart';

class OverlayImage extends StatelessWidget {
  final Widget child;

  const OverlayImage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return MatrixGestureDetector(
      onMatrixUpdate: (matrix, translationDeltaMatrix, scaleDeltaMatrix,
          rotationDeltaMatrix) {
        notifier.value = matrix;
      },
      onScaleStart: () {
        context.read<PaintBloc>().onUpdateDrag();
      },
      onScaleEnd: () {
        context.read<PaintBloc>().onUpdateDraw();
      },
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
