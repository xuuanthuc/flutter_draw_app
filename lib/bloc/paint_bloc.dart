import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:paint_app/model/draw_model.dart';

part 'paint_event.dart';
part 'paint_state.dart';

class PaintBloc extends Bloc<PaintEvent, PaintState> {
  PaintBloc()
      : super(PaintInitial()) {
    on<OnPaintingEvent>(_onPaint);
    on<OnSelectStokeSizeEvent>(_onSelectStoke);
    on<OnSelectPaintColorEvent>(_onSelectColor);
  }

  void _onPaint(OnPaintingEvent event, Emitter<PaintState> emit){
    emit(OnPaintingState());
    emit(OnPaintedState(event.listOffset));
  }

  void _onSelectStoke(OnSelectStokeSizeEvent event, Emitter<PaintState> emit){
    emit(OnPaintingState());
    emit(OnSelectedStokeSizeState(event.size));
  }

  void _onSelectColor(OnSelectPaintColorEvent event, Emitter<PaintState> emit){
    emit(OnPaintingState());
    emit(OnSelectedPaintColorState(event.color));
  }
}