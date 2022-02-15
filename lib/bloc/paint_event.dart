part of 'paint_bloc.dart';

abstract class PaintEvent extends Equatable {
  const PaintEvent();

  @override
  List<Object> get props => [];
}

class OnPaintingEvent extends PaintEvent {
  final List<DrawLine> listOffset;
  const OnPaintingEvent(this.listOffset);
}

class OnSelectStokeSizeEvent extends PaintEvent{
  final double size;
  const OnSelectStokeSizeEvent(this.size);
}


class OnSelectPaintColorEvent extends PaintEvent{
  final Color color;
  const OnSelectPaintColorEvent(this.color);
}