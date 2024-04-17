part of 'paint_bloc.dart';

enum PaintAction { draw, erase }

@immutable
class PaintState extends Equatable {
  final List<DrawLine>? listOffset;
  final PaintAction? action;
  final double? size;
  final Color? color;
  final DrawLine? line;

  const PaintState({
    this.listOffset,
    this.size,
    this.color,
    this.line,
    this.action,
  });

  PaintState copyWith(
      {List<DrawLine>? listOffset,
      double? size,
      Color? color,
      DrawLine? line,
      PaintAction? action}) {
    return PaintState(
      listOffset: listOffset ?? this.listOffset,
      color: color ?? this.color,
      size: size ?? this.size,
      line: line ?? this.line,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
        listOffset,
        size,
        color,
        line,
        action,
      ];
}
