import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/model/draw_model.dart';
import 'package:paint_app/screen/paint/widget/footer_tool_widget.dart';

import '../../bloc/paint_bloc.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({Key? key}) : super(key: key);

  @override
  _PaintScreenState createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PaintBloc, PaintState>(
      listener: (context, state) {},
      child: BlocBuilder<PaintBloc, PaintState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onPanDown: (point) {
                      var paint = Paint();
                      if (state.action == PaintAction.erase) {
                        paint = Paint()
                          ..color = Colors.red.withOpacity(0.1)
                          ..strokeWidth = 50
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke;
                      } else {
                        paint
                          ..color = state.color ?? Colors.black
                          ..strokeWidth = state.size ?? 2
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke;
                      }
                      context.read<PaintBloc>().onPaint(DrawLine(
                            point: point.globalPosition,
                            paint: paint,
                            action: state.action ?? PaintAction.draw,
                          ));
                    },
                    onPanUpdate: (point) {
                      var paint = Paint();
                      if (state.action == PaintAction.erase) {
                        paint = Paint()
                          ..color = Colors.red.withOpacity(0.1)
                          ..strokeWidth = 50
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke;
                      } else {
                        paint
                          ..color = state.color ?? Colors.black
                          ..strokeWidth = state.size ?? 2
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke;
                      }

                      context.read<PaintBloc>().onPaint(DrawLine(
                            point: point.globalPosition,
                            paint: paint,
                            action: state.action ?? PaintAction.draw,
                          ));
                    },
                    onPanEnd: (point) {
                      var paint = Paint();
                      if (state.action == PaintAction.erase) {
                        paint = Paint()
                          ..color = Colors.red.withOpacity(0.1)
                          ..strokeWidth = 50
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke;
                        context.read<PaintBloc>().clearErasePaint();
                      } else {
                        paint
                          ..color = state.color ?? Colors.black
                          ..strokeWidth = state.size ?? 2
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke;
                        context.read<PaintBloc>().onPaint(
                          DrawLine(
                              point: Offset.zero,
                              paint: paint,
                              action: state.action ?? PaintAction.draw),
                        );
                      }
                    },
                    child: CustomPaint(
                      painter: CardPaint(state.listOffset ?? []),
                      child: Container(),
                    ),
                  ),
                ),
                FooterTool(listLine: state.listOffset ?? [])
              ],
            ),
          );
        },
      ),
    );
  }
}

class CardPaint extends CustomPainter {
  final List<DrawLine> listOffset;

  CardPaint(this.listOffset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.largest, Paint());
    for (var i = 0; i < listOffset.length - 1; i++) {
      if (listOffset[i].point != Offset.zero &&
          listOffset[i + 1].point != Offset.zero) {
        var paint = listOffset[i].paint;
        canvas.drawLine(listOffset[i].point, listOffset[i + 1].point, paint);
      } else {
        var paint = listOffset[i].paint;
        canvas.drawPoints(PointMode.points, [listOffset[i].point], paint);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
