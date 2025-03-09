import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_ani/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final scheduler = SchedulerBinding.instance;
  scheduler.platformDispatcher.onBeginFrame = null;
  scheduler.platformDispatcher.onDrawFrame = null;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
