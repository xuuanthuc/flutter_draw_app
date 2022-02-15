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
  List<DrawLine> _listOffset = [];
  double _paintSize = 2.0;
  Color _paintColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaintBloc, PaintState>(
      listener: (context, state) {
        if (state is OnPaintedState) {
          _listOffset = state.listOffset;
        }
        if (state is OnSelectedStokeSizeState) {
          _paintSize = state.size;
        }
        if (state is OnSelectedPaintColorState) {
          _paintColor = state.color;
        }
      },
      child: BlocBuilder<PaintBloc, PaintState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onPanDown: (point) {
                      _listOffset.add(DrawLine(
                          point: point.globalPosition,
                          paint: Paint()
                            ..color = _paintColor
                            ..strokeWidth = _paintSize
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.stroke));
                      context
                          .read<PaintBloc>()
                          .add(OnPaintingEvent(_listOffset));
                    },
                    onPanUpdate: (point) {
                      _listOffset.add(DrawLine(
                          point: point.globalPosition,
                          paint: Paint()
                            ..color = _paintColor
                            ..strokeWidth = _paintSize
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.stroke));
                      context
                          .read<PaintBloc>()
                          .add(OnPaintingEvent(_listOffset));
                    },
                    onPanEnd: (point) {
                      _listOffset.add(DrawLine(
                          point: Offset.zero,
                          paint: Paint()
                            ..color = _paintColor
                            ..strokeWidth = _paintSize
                            ..strokeCap = StrokeCap.round
                            ..style = PaintingStyle.stroke));
                      context
                          .read<PaintBloc>()
                          .add(OnPaintingEvent(_listOffset));
                    },
                    child: CustomPaint(
                      painter: CardPaint(_listOffset),
                      child: Container(),
                    ),
                  ),
                ),
                FooterTool(listLine: _listOffset)
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
