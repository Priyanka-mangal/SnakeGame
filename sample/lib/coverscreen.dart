import 'package:flutter/material.dart';

class MyCoverScreen extends StatelessWidget {
  final bool gameHasStarted;

  const MyCoverScreen({required this.gameHasStarted, super.key});

  @override
  Widget build(BuildContext context) {
    if (gameHasStarted) {
      return const SizedBox.shrink(); // Return an empty widget if the game has started
    }
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'T A P  T O  P L A Y',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
