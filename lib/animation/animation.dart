import 'package:animations_prep/animation/example.dart';
import 'package:flutter/material.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();

    _selected = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Align'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ExampleWidget(),
                ),
              );
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: AnimatedAlign(
        alignment: _selected ? Alignment.topCenter : Alignment.bottomCenter,
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
        child: Container(
          width: 200,
          height: 200,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Center(
            child: Text('Animated Align'),
          ),
        ),
      ),
    );
  }
}
