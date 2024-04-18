import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/model/draw_model.dart';
import 'package:paint_app/screen/widget/overlay_image.dart';
import 'package:paint_app/screen/widget/tools.dart';

import '../bloc/paint_bloc.dart';

class PaintScreen extends StatefulWidget {
  const PaintScreen({Key? key}) : super(key: key);

  @override
  _PaintScreenState createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  final List<Widget> _images = [];
  bool _canDelete = false;
  final GlobalKey _deleteStickerIcon = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final trashStickerIconPs = Offset(MediaQuery.sizeOf(context).width / 2,
        MediaQuery.sizeOf(context).height - 20);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: BlocBuilder<PaintBloc, PaintState>(
          buildWhen: (_, cur) => cur.action == PaintAction.newSticker,
          builder: (context, state) {
            if (state.newSticker != null) {
              _images.add(
                OverlayImage(
                  child: state.newSticker!,
                  key: Key(
                    _images.length.toString(),
                  ),
                  onScaleEnd: (key) {
                    if (_canDelete) {
                      context.read<PaintBloc>().deleteSticker(key!);
                    }
                    context.read<PaintBloc>().onUpdateDraw();
                  },
                  onScaleStart: (offset) {
                    bool canDelete = false;
                    if ((trashStickerIconPs - offset).distance.abs() < 30) {
                      canDelete = true;
                    }
                    context.read<PaintBloc>().onUpdateDrag(canDelete);
                  },
                ),
              );
            }

            if (state.stickerDeleted != null) {
              _images.removeWhere(
                  (element) => element.key == state.stickerDeleted);
            }
            return Stack(
              alignment: Alignment.center,
              children: [
                RepaintBoundary(
                  child: BlocBuilder<PaintBloc, PaintState>(
                    builder: (context, state) {
                      var paint = Paint();
                      if (state.action == PaintAction.erase) {
                        paint = Paint()
                          ..blendMode = BlendMode.clear
                          ..strokeWidth = 10
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke;
                      } else {
                        paint
                          ..color = state.color ?? Colors.black
                          ..strokeWidth = state.size ?? 2
                          ..strokeCap = StrokeCap.round
                          ..style = PaintingStyle.stroke;
                      }
                      return GestureDetector(
                        onPanDown: (point) {
                          if (state.action == PaintAction.none) return;
                          context.read<PaintBloc>().onPaint(DrawLine(
                                point: point.globalPosition,
                                paint: paint,
                                action: state.action ?? PaintAction.draw,
                              ));
                        },
                        onPanUpdate: (point) {
                          if (state.action == PaintAction.none) return;
                          context.read<PaintBloc>().onPaint(DrawLine(
                                point: point.globalPosition,
                                paint: paint,
                                action: state.action ?? PaintAction.draw,
                              ));
                        },
                        onPanEnd: (point) {
                          if (state.action == PaintAction.none) return;
                          context.read<PaintBloc>().onPaint(DrawLine(
                                point: Offset.zero,
                                paint: paint,
                                action: state.action ?? PaintAction.draw,
                              ));
                        },
                        child: RepaintBoundary(
                          child: CustomPaint(
                            isComplex: true,
                            willChange: false,
                            painter: CardPaint(state.listOffset ?? []),
                            child: Container(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                for (int i = 0; i < _images.length; i++) _images[i],
                const Positioned(
                  top: 80,
                  right: 10,
                  child: ToolSelection(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BlocBuilder<PaintBloc, PaintState>(
                    key: _deleteStickerIcon,
                    builder: (context, state) {
                      _canDelete = state.canDelete ?? false;
                      return Opacity(
                        opacity: state.action == PaintAction.none ? 1 : 0,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: (state.canDelete ?? false)
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
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
  bool shouldRepaint(covariant CardPaint oldDelegate) {
    return true;
  }
}
