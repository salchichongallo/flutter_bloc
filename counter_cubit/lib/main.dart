import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_flutter_counter/app.dart';
import 'package:bloc_flutter_counter/counter_observer.dart';

void main() {
  Bloc.observer = CounterObserver();
  runApp(const CounterApp());
}
