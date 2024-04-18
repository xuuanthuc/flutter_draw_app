import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/bloc/paint_bloc.dart';
import 'package:paint_app/screen/paint_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaintBloc>(
      create: (context) => PaintBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PaintScreen(),
      ),
    );
  }
}