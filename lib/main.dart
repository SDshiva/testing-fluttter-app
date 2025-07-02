import 'package:flutter/material.dart';
import 'package:testing/screen/counter_screen.dart';

import 'controller/counter_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CounterScreen(
        counterService: CounterService(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
