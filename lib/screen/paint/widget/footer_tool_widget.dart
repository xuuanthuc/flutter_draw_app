import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint_app/bloc/paint_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/model/draw_model.dart';

class FooterTool extends StatefulWidget {
  List<DrawLine> listLine;

  FooterTool({Key? key, required this.listLine}) : super(key: key);

  @override
  State<FooterTool> createState() => _FooterToolState();
}

class _FooterToolState extends State<FooterTool> {
  Color pickerColor = const Color(0xff443a49);
  double size = 2;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _selectSize(context),
          _selectColor(context),
          _selectClearAll(context),
          // InkWell(
          //   onTap: () {},
          //   child: Container(
          //     child: Icon(CupertinoIcons.earse),
          //   ),
          // )
        ],
      ),
    );
  }

  InkWell _selectClearAll(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        context.read<PaintBloc>().add(
            OnPaintingEvent([DrawLine(point: Offset.zero, paint: Paint())]));
      },
      child: Container(
        color: Colors.transparent,
        height: 40,
        width: 40,
        child: Icon(
          CupertinoIcons.delete_solid,
          color: Colors.grey,
        ),
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
              // Use Material color picker:
              //
              // child: MaterialPicker(
              //   pickerColor: pickerColor,
              //   onColorChanged: changeColor,
              //   // showLabel: true, // only on portrait mode
              // ),
              //
              // Use Block color picker:
              //
              // child: BlockPicker(
              //   pickerColor: currentColor,
              //   onColorChanged: changeColor,
              // ),
              //
              // child: MultipleChoiceBlockPicker(
              //   pickerColors: currentColors,
              //   onColorsChanged: changeColors,
              // ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Select'),
                onPressed: () {
                  context
                      .read<PaintBloc>()
                      .add(OnSelectPaintColorEvent(pickerColor));
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
        color: Colors.transparent,
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
      child: Container(
        height: 40,
        width: 40,
        color: Colors.transparent,
        child: Icon(
          Icons.edit,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _sizeOption(double currenSize) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        size = currenSize;
        context.read<PaintBloc>().add(OnSelectStokeSizeEvent(size));
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
