import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/model/draw_model.dart';
import 'package:paint_app/screen/widget/overlay_image.dart';
import 'package:paint_app/screen/widget/tools.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

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
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isShowSticker = false;

  List<Widget> images = [
    Image.asset("assets/bear.png"),
    Image.asset("assets/cat.png"),
    Image.asset("assets/dog.png"),
    Image.asset("assets/eagle.png"),
    Image.asset("assets/turtle.png"),
    Image.asset("assets/pinguin.png"),
  ];

  @override
  Widget build(BuildContext context) {
    final trashStickerIconPs = Offset(MediaQuery.sizeOf(context).width / 2,
        MediaQuery.sizeOf(context).height - 20);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Screenshot(
            controller: _screenshotController,
            child: DragTarget(
                onAcceptWithDetails: (DragTargetDetails<Widget> details) {
              setState(() {
                _isShowSticker = false;
              });
              context.read<PaintBloc>().addNewImage(details.data);
            }, builder: (context, a, r) {
              return Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                color: Colors.white,
                child: BlocBuilder<PaintBloc, PaintState>(
                  buildWhen: (prev, cur) =>
                      cur.newSticker != prev.newSticker ||
                      cur.action == PaintAction.sticker,
                  builder: (context, state) {
                    if (state.newSticker != null) {
                      context.read<PaintBloc>().onUpdateDraw();
                      _images.add(
                        OverlayImage(
                          child: state.newSticker!,
                          key: Key(const Uuid().v4()),
                          onScaleEnd: (key) {
                            if (_canDelete) {
                              context.read<PaintBloc>().deleteSticker(key!);
                            }
                            context.read<PaintBloc>().onUpdateDraw();
                          },
                          onScaleStart: (offset) {
                            bool canDelete = false;
                            if ((trashStickerIconPs - offset).distance.abs() <
                                30) {
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
                                  ..strokeWidth = 30
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
                                  if (state.action == PaintAction.drag) return;
                                  context.read<PaintBloc>().onPaint(DrawLine(
                                        point: point.globalPosition,
                                        paint: paint,
                                        action:
                                            state.action ?? PaintAction.draw,
                                      ));
                                },
                                onPanUpdate: (point) {
                                  if (state.action == PaintAction.drag) return;
                                  context.read<PaintBloc>().onPaint(DrawLine(
                                        point: point.globalPosition,
                                        paint: paint,
                                        action:
                                            state.action ?? PaintAction.draw,
                                      ));
                                },
                                onPanEnd: (point) {
                                  if (state.action == PaintAction.drag) return;
                                  context.read<PaintBloc>().onPaint(DrawLine(
                                        point: Offset.zero,
                                        paint: paint,
                                        action:
                                            state.action ?? PaintAction.draw,
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
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: BlocBuilder<PaintBloc, PaintState>(
                            key: _deleteStickerIcon,
                            builder: (context, state) {
                              _canDelete = state.canDelete ?? false;
                              return Opacity(
                                opacity:
                                    state.action == PaintAction.drag ? 1 : 0,
                                child: IconButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.grey.withOpacity(0.1),
                                    ),
                                  ),
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
              );
            }),
          ),
          Positioned(
            top: 80,
            right: 10,
            child: ToolSelection(
              showSticker: () {
                setState(() {
                  _isShowSticker = !_isShowSticker;
                });
                context.read<PaintBloc>().onUpdateSticker();
              },
              onSave: () {
                _screenshotController.capture().then((image) async {
                  final dir = await getExternalStorageDirectory();
                  final myImagePath = dir!.path +
                      "/${DateTime.now().millisecondsSinceEpoch}.png";
                  File imageFile = File(myImagePath);
                  if (!await imageFile.exists()) {
                    imageFile.create(recursive: true);
                  }
                  imageFile.writeAsBytes(image as List<int>);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Save to $myImagePath"),
                  ));
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Visibility(
              visible: _isShowSticker,
              child: Container(
                margin: const EdgeInsets.only(top: 62, left: 10, right: 60),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: LongPressDraggable<Widget>(
                        data: images[index],
                        feedback: images[index],
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: images[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
