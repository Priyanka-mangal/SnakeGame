import "dart:async";
import "package:flutter/material.dart";
import "package:sample/bird.dart";
import "package:sample/barrier.dart";
import 'package:sample/coverscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Bird variables
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -2.5; // Gravity
  double velocity = 2.5; // Jump force
  double birdWidth = 0.1; // Bird's width relative to screen
  double birdHeight = 0.1; // Bird's height relative to screen

  // Game settings
  bool gameHasStarted = false;

  // Barrier variables
  static List<double> barrierX = [2, 3.5]; // Positions of barriers
  static double barrierWidth = 0.5; // Barrier width
  List<List<double>> barrierHeight = [
    [0.6, 0.4], // Heights of top and bottom barriers
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // Calculate height (physics formula)
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;

        // Update barrier positions
        for (int i = 0; i < barrierX.length; i++) {
          barrierX[i] -= 0.005; // Barrier movement speed
          if (barrierX[i] < -1.5) {
            // Reset barrier position when out of screen
            barrierX[i] += 3;
          }
        }
      });

      // Check if bird is dead
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }

      // Increment time for physics calculation
      time += 0.02;
    });
  }

  void resetGame() {
    Navigator.pop(context); // Dismiss the alert dialog
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
      barrierX = [2, 3.5]; // Reset barrier positions
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: const Center(
              child: Text(
                "G A M E  O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      'P L A Y  A G A I N',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    // Check if the bird hits the screen boundaries
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    // Check for collisions with barriers
    for (int i = 0; i < barrierX.length; i++) {
      bool inBarrierXRange =
          (barrierX[i] - barrierWidth / 2 <= birdWidth / 2) &&
              (barrierX[i] + barrierWidth / 2 >= -birdWidth / 2);

      bool inBarrierYRange =
          (birdY - birdHeight / 2 < -1 + barrierHeight[i][0]) ||
              (birdY + birdHeight / 2 > 1 - barrierHeight[i][1]);

      if (inBarrierXRange && inBarrierYRange) {
        return true; // Collision detected
      }
    }

    return false; // No collision
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      // Bird widget
                      MyBird(
                        birdY: birdY,
                        birdHeight: birdHeight,
                        birdWidth: birdWidth,
                      ),
                      // Cover screen
                      MyCoverScreen(gameHasStarted: gameHasStarted),

                      // Top barrier 0
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),
                      // Bottom barrier 0
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),
                      // Top barrier 1
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),
                      // Bottom barrier 1
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
