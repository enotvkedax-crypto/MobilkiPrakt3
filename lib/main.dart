import 'package:flutter/material.dart';
import 'package:prakt3/widgets/dog_list.dart';
import 'package:prakt3/core/dio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyManager.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: const DogList(),
    );
  }
}
