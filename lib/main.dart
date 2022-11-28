import 'package:flutter/material.dart';

const int squareSide = 3;

///First color for empty cell, Second color for Player 1 cell, Third color for Player 2 cell
const List<Color> usedColors = <Color>[Colors.white, Colors.green, Colors.red];
const List<List<int>> emptyScoreMatrix = <List<int>>[
  <int>[0, 0, 0],
  <int>[0, 0, 0],
  <int>[0, 0, 0]
];

void main() {
  runApp(const TicTacToeGame());
}

class TicTacToeGame extends StatelessWidget {
  const TicTacToeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.yellow),
      ),
      home: const GameMainScreen(),
    );
  }
}

class GameMainScreen extends StatefulWidget {
  const GameMainScreen({super.key});

  @override
  State<GameMainScreen> createState() => _GameMainScreenState();
}

class _GameMainScreenState extends State<GameMainScreen> {
  List<List<int>> scoredCells = <List<int>>[
    <int>[0, 0, 0],
    <int>[0, 0, 0],
    <int>[0, 0, 0]
  ];

  int currentPlayer = 1;
  int filledCellsCount = 0;

  ///There are 3 lines in the grid without the "Reset" button and 4 lines with it
  int numberOfLines = squareSide;

  void resetCells() {
    scoredCells = <List<int>>[
      <int>[0, 0, 0],
      <int>[0, 0, 0],
      <int>[0, 0, 0]
    ];
  }

  void changePlayer() {
    if (currentPlayer == 1) {
      currentPlayer = 2;
    } else {
      currentPlayer = 1;
    }
  }

  void checkMatrix() {
    ///check lines
    for (int i = 0; i < squareSide; i++) {
      bool flag = true;
      int winner = 0;
      for (int j = 0; j < squareSide - 1; j++) {
        winner = scoredCells[i][j];
        if (scoredCells[i][j] != scoredCells[i][j + 1] || scoredCells[i][j] == 0) {
          flag = false;
        }
      }
      if (flag) {
        setState(() {
          resetCells();
          for (int k = 0; k < squareSide; k++) {
            scoredCells[i][k] = winner;
          }
          numberOfLines = 4;
        });
        return;
      }
    }

    ///check columns
    for (int j = 0; j < squareSide; j++) {
      bool flag = true;
      int winner = 0;
      for (int i = 0; i < squareSide - 1; i++) {
        winner = scoredCells[i][j];
        if (scoredCells[i][j] != scoredCells[i + 1][j] || scoredCells[i][j] == 0) {
          flag = false;
        }
      }
      if (flag) {
        setState(() {
          resetCells();
          for (int k = 0; k < squareSide; k++) {
            scoredCells[k][j] = winner;
          }
          numberOfLines = 4;
        });
        return;
      }
    }

    ///check main diagonal
    bool flag = true;
    int winner = 0;
    for (int i = 0; i < squareSide - 1; i++) {
      winner = scoredCells[i][i];
      if (scoredCells[i][i] != scoredCells[i + 1][i + 1] || scoredCells[i][i] == 0) {
        flag = false;
      }
    }
    if (flag) {
      setState(() {
        resetCells();
        for (int k = 0; k < squareSide; k++) {
          scoredCells[k][k] = winner;
        }
        numberOfLines = 4;
      });
      return;
    }

    ///check main diagonal
    bool flagSecond = true;
    int winnerSecond = 0;
    for (int i = 0; i < squareSide - 1; i++) {
      winnerSecond = scoredCells[i][squareSide - i - 1];
      if (scoredCells[i][squareSide - i - 1] != scoredCells[i + 1][squareSide - i - 2] ||
          scoredCells[i][squareSide - i - 1] == 0) {
        flagSecond = false;
      }
    }
    if (flagSecond) {
      setState(() {
        resetCells();
        for (int k = 0; k < squareSide; k++) {
          scoredCells[k][squareSide - k - 1] = winnerSecond;
        }
        numberOfLines = 4;
      });
      return;
    }

    ///check if it is tie and all cells are checked
    if (filledCellsCount == squareSide * squareSide) {
      setState(() {
        numberOfLines = 4;
      });
    }
  }

  List<Widget> generateGridElements() {
    return List<Widget>.generate(squareSide * numberOfLines, (int index) {
      if (index < squareSide * squareSide) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (scoredCells[index ~/ 3][index % 3] == 0) {
                scoredCells[index ~/ 3][index % 3] = currentPlayer;
                filledCellsCount++;
                changePlayer();
                checkMatrix();
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: usedColors[scoredCells[index ~/ 3][index % 3]],
          ),
        );
      } else {
        ///If the "Reset" button is needed a row wth two colored box and the button between is added
        if (index == squareSide * squareSide + 1) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  numberOfLines = squareSide;
                  resetCells();
                  filledCellsCount = 0;
                });
              },
              child: const Text('Reset'),
            ),
          );
        } else {
          return const ColoredBox(
            color: Colors.black,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Tic Tac Toe'),
        ),
      ),
      body: ColoredBox(
        color: Colors.black,
        child: GridView.count(
          crossAxisCount: squareSide,
          padding: const EdgeInsets.all(3),
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          children: generateGridElements(),
        ),
      ),
    );
  }
}
