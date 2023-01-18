import 'package:bloc_flutter_counter/counter/view/counter_page.dart';
import 'package:flutter/material.dart';

class CounterApp extends MaterialApp {
  const CounterApp({super.key})
      : super(
          title: 'Counter',
          home: const CounterPage(),
        );
}
