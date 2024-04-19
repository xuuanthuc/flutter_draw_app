part of 'paint_bloc.dart';

enum PaintAction { draw, erase, sticker, drag }

@immutable
class PaintState extends Equatable {
  final List<DrawLine>? listOffset;
  final List<Widget>? images;
  final Widget? newSticker;
  final Key? stickerDeleted;
  final PaintAction? action;
  final double? size;
  final Color? color;
  final DrawLine? line;
  final bool? canDelete;

  const PaintState({
    this.listOffset,
    this.size,
    this.color,
    this.images,
    this.line,
    this.action,
    this.newSticker,
    this.stickerDeleted,
    this.canDelete,
  });

  PaintState copyWith({
    List<DrawLine>? listOffset,
    double? size,
    Color? color,
    DrawLine? line,
    PaintAction? action,
    List<Widget>? images,
    Widget? newSticker,
    Key? stickerDeleted,
    bool? canDelete,
  }) {
    return PaintState(
      listOffset: listOffset ?? this.listOffset,
      color: color ?? this.color,
      size: size ?? this.size,
      line: line ?? this.line,
      action: action ?? this.action,
      images: images ?? this.images,
      newSticker: newSticker,
      stickerDeleted: stickerDeleted,
      canDelete: canDelete ?? this.canDelete,
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
        canDelete,
        stickerDeleted,
      ];
}
