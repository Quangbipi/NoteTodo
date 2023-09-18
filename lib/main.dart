import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_todo/app.dart';
import 'package:note_todo/bloc/bloc_observer.dart';

void main() {
  Bloc.observer = TodoObserver();
  runApp(const MyApp());
}



