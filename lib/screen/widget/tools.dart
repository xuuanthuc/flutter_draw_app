import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint_app/bloc/paint_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolSelection extends StatefulWidget {
  final Function onSave;

  const ToolSelection({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<ToolSelection> createState() => _ToolSelectionState();
}

class _ToolSelectionState extends State<ToolSelection> {
  Color pickerColor = const Color(0xff443a49);
  double size = 2;
  List<Widget> images = [
    Image.asset("assets/bear.png"),
    Image.asset("assets/cat.png"),
    Image.asset("assets/dog.png"),
    Image.asset("assets/eagle.png"),
    Image.asset("assets/turtle.png"),
    Image.asset("assets/pinguin.png"),
  ];

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: [
        _selectSticker(context),
        const SizedBox(height: 10),
        _selectSize(context),
        const SizedBox(height: 10),
        _selectColor(context),
        const SizedBox(height: 10),
        _selectClearAll(context),
        const SizedBox(height: 10),
        _selectSave(onSave: () => widget.onSave()),
      ],
    );
  }

  InkWell _selectSave({required Function onSave}) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () => onSave(),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Icon(
          CupertinoIcons.square_arrow_down,
          color: Colors.blue,
        ),
      ),
    );
  }

  InkWell _selectClearAll(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        context.read<PaintBloc>().onErase();
      },
      child: BlocBuilder<PaintBloc, PaintState>(
        buildWhen: (prev, curr) => prev.action != curr.action,
        builder: (context, state) {
          return Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Icon(
              CupertinoIcons.delete_solid,
              color: state.action == PaintAction.erase
                  ? Colors.black
                  : Colors.grey,
            ),
          );
        },
      ),
    );
  }

  InkWell _selectSticker(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () async {
        await showDialog<Widget?>(
          barrierColor: Colors.grey.withOpacity(0.1),
          context: context,
          builder: (context) => Dialog(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(images[index]);
                        },
                        child: images[index]),
                  );
                },
              ),
            ),
          ),
        ).then((value) {
          if (value != null) context.read<PaintBloc>().addNewImage(value);
        });
      },
      child: BlocBuilder<PaintBloc, PaintState>(
        buildWhen: (prev, curr) => prev.action != curr.action,
        builder: (context, state) {
          return Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Icon(
              CupertinoIcons.wand_stars,
              color: state.action == PaintAction.sticker
                  ? Colors.black
                  : Colors.grey,
            ),
          );
        },
      ),
    );
  }

  InkWell _selectColor(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        showDialog(
          barrierColor: Colors.grey.withOpacity(0.1),
          context: context,
          builder: (context) => AlertDialog(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Select'),
                onPressed: () {
                  context.read<PaintBloc>().onSelectColor(pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(
          CupertinoIcons.paintbrush_fill,
          color: pickerColor,
        ),
      ),
    );
  }

  InkWell _selectSize(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        showDialog(
          barrierColor: Colors.grey.withOpacity(0.1),
          context: context,
          builder: (context) => AlertDialog(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sizeOption(2),
                  _sizeOption(3),
                  _sizeOption(4),
                  _sizeOption(5),
                  _sizeOption(6),
                  _sizeOption(7),
                  _sizeOption(8),
                  _sizeOption(9),
                  _sizeOption(10),
                ],
              ),
            ),
          ),
        );
      },
      child: BlocBuilder<PaintBloc, PaintState>(
        buildWhen: (prev, curr) => prev.action != curr.action,
        builder: (context, state) {
          return Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey.withOpacity(0.1),
            ),
            child: Icon(
              CupertinoIcons.pen,
              color:
                  state.action == PaintAction.draw ? Colors.black : Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget _sizeOption(double currenSize) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        size = currenSize;
        context.read<PaintBloc>().onSelectStoke(size);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Container(
          height: currenSize,
          decoration: BoxDecoration(
            color: size == currenSize ? Colors.black : Colors.black12,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
