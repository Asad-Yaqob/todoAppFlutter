import 'package:flutter/material.dart';

import 'package:animations_prep/screens/todos.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade200),
      ),
      home: const TodosScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
