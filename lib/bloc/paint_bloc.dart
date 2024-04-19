import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:paint_app/model/draw_model.dart';

part 'paint_state.dart';

@injectable
class PaintBloc extends Cubit<PaintState> {
  PaintBloc() : super(const PaintState(action: PaintAction.draw));

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

  void onUpdateDraw() {
    emit(state.copyWith(action: PaintAction.draw));
  }

  void onUpdateDrag(bool canDelete) {
    emit(state.copyWith(
      action: PaintAction.drag,
      canDelete: canDelete,
    ));
  }

  void onSelectStoke(double size) {
    emit(state.copyWith(size: size, action: PaintAction.draw));
  }

  void onSelectColor(Color color) {
    emit(state.copyWith(color: color, action: PaintAction.draw));
  }

  void addNewImage(Widget image) {
    emit(
      state.copyWith(
        newSticker: image,
        action: PaintAction.sticker,
      ),
    );
    emit(state.copyWith(action: PaintAction.draw));
  }

  void deleteSticker(Key key) {
    emit(state.copyWith(
      stickerDeleted: key,
      action: PaintAction.sticker,
    ));
    emit(state.copyWith(
      action: PaintAction.draw,
      canDelete: false,
    ));
  }
}
