part of 'paint_bloc.dart';

enum PaintAction { draw, erase, newSticker, none }

@immutable
class PaintState extends Equatable {
  final List<DrawLine>? listOffset;
  final List<Widget>? images;
  final Widget? newSticker;
  final PaintAction? action;
  final double? size;
  final Color? color;
  final DrawLine? line;

  const PaintState({
    this.listOffset,
    this.size,
    this.color,
    this.images,
    this.line,
    this.action,
    this.newSticker,
  });

  PaintState copyWith({
    List<DrawLine>? listOffset,
    double? size,
    Color? color,
    DrawLine? line,
    PaintAction? action,
    List<Widget>? images,
    Widget? newSticker,
  }) {
    return PaintState(
      listOffset: listOffset ?? this.listOffset,
      color: color ?? this.color,
      size: size ?? this.size,
      line: line ?? this.line,
      action: action ?? this.action,
      images: images ?? this.images,
      newSticker: newSticker,
    );
  }

  @override
  List<Object?> get props => [
        listOffset,
        size,
        color,
        line,
        action,
        images,
        newSticker,
      ];
}
