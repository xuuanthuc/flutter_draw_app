import 'package:flutter/cupertino.dart';
import 'package:paint_app/bloc/paint_bloc.dart';

class DrawLine {
  Offset point;
  Paint paint;
  PaintAction action;

  DrawLine({
    required this.point,
    required this.paint,
    required this.action,
  });
}
