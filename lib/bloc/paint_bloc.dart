import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:paint_app/model/draw_model.dart';

part 'paint_event.dart';

part 'paint_state.dart';

@injectable
class PaintBloc extends Cubit<PaintState> {
  PaintBloc() : super(const PaintState());

  void onPaint(DrawLine line) {
    emit(state.copyWith(
      listOffset: (state.listOffset ?? [])..add(line),
      line: line,
    ));
  }

  void onErase() {
    emit(state.copyWith(
        action: state.action == PaintAction.erase
            ? PaintAction.draw
            : PaintAction.erase));
  }

  void clearErasePaint() {
    for (DrawLine pa in state.listOffset ?? []) {
      if (pa.action == PaintAction.erase) {
        pa.paint.blendMode = BlendMode.clear;
      }
    }
    emit(state.copyWith(
      listOffset: state.listOffset,
      line: DrawLine(
        point: const Offset(0, 0),
        paint: Paint(),
        action: PaintAction.draw,
      ),
    ));
  }

  void onSelectStoke(double size) {
    emit(state.copyWith(size: size, action: PaintAction.draw));
  }

  void onSelectColor(Color color) {
    emit(state.copyWith(color: color, action: PaintAction.draw));
  }
}
