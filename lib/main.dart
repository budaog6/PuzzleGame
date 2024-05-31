import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(PuzzleApp());
}

class PuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Game',
      home: PuzzleHome(),
    );
  }
}

class PuzzleHome extends StatefulWidget {
  @override
  _PuzzleHomeState createState() => _PuzzleHomeState();
}

class _PuzzleHomeState extends State<PuzzleHome> {
  List<String> parts = [
    'assets/part1.png',
    'assets/part2.png',
    'assets/part3.png',
    'assets/part4.png',
    'assets/part5.png',
    'assets/part6.png',
    'assets/part7.png',
    'assets/part8.png',
  ];
  List<int> positions = [];
  int emptyTileIndex = 8; // Инициализация переменной пустой плитки

  @override
  void initState() {
    super.initState();
    resetPuzzle();
  }

  void resetPuzzle() {
    parts.shuffle();
    positions = List<int>.generate(parts.length, (index) => index);
    positions.add(emptyTileIndex); // Добавление индекса пустой плитки
    setState(() {});
  }

  Widget createTile(String assetPath, int index) {
    return GestureDetector(
      onTap: () => moveTile(index),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
        width: 100,
        height: 100,
      ),
    );
  }

  Widget createEmptyTile() {
    return Container(
      color: Colors.transparent,
      width: 100,
      height: 100,
    );
  }

  void moveTile(int index) {
    setState(() {
      if (isValidMove(index)) {
        int temp = positions[emptyTileIndex];
        positions[emptyTileIndex] = positions[index];
        positions[index] = temp;
        emptyTileIndex = index;

        if (isPuzzleSolved()) {
          showWinPopup();
        }
      }
    });
  }

  bool isValidMove(int index) {
    int row = index ~/ 3;
    int col = index % 3;
    int emptyRow = emptyTileIndex ~/ 3;
    int emptyCol = emptyTileIndex % 3;

    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
           (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  bool isPuzzleSolved() {
    for (int i = 0; i < parts.length; i++) {
      if (positions[i] != i) {
        return false;
      }
    }
    return true;
  }

  void showWinPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Победа!'),
          content: Text('Вы выиграли!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 310,
              height: 310,
              child: GridView.builder(
                itemCount: 9, // Устанавливаем количество элементов в GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  if (index == emptyTileIndex) {
                    return createEmptyTile();
                  } else {
                    return createTile(parts[positions[index]], index);
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPuzzle,
              child: Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }
}
