part of 'paint_bloc.dart';

abstract class PaintState extends Equatable {
  const PaintState();

  @override
  List<Object> get props => [];
}

class PaintInitial extends PaintState {}

class OnPaintingState extends PaintState {}

class OnPaintedState extends PaintState {
  final List<DrawLine> listOffset;
  const OnPaintedState(this.listOffset);
}

class OnSelectedStokeSizeState extends PaintState{
  final double size;
  const OnSelectedStokeSizeState(this.size);
}

class OnSelectedPaintColorState extends PaintState{
  final Color color;
  const OnSelectedPaintColorState(this.color);
}
