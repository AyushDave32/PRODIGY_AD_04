import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.teal[50],
      ),
      home: TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  String currentPlayer = 'X';
  String? winner;
  bool isBoardDisabled = false;
  int xWins = 0;
  int oWins = 0;

  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      currentPlayer = 'X';
      winner = null;
      isBoardDisabled = false;
    });
  }

  void _restartGame() {
    setState(() {
      _resetGame();
    });
  }

  void _resetScoreboard() {
    setState(() {
      xWins = 0;
      oWins = 0;
    });
  }

  void _makeMove(int row, int col) {
    if (board[row][col].isEmpty && winner == null && !isBoardDisabled) {
      setState(() {
        board[row][col] = currentPlayer;
        if (_checkWinner(row, col)) {
          winner = currentPlayer;
          if (winner == 'X') {
            xWins++;
          } else if (winner == 'O') {
            oWins++;
          }
          isBoardDisabled = true;
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(int row, int col) {
    // Check row
    if (board[row].every((cell) => cell == currentPlayer)) {
      return true;
    }
    // Check column
    if (board.every((r) => r[col] == currentPlayer)) {
      return true;
    }
    // Check diagonal
    if (row == col &&
        board.every((r) => r[board.indexOf(r)] == currentPlayer)) {
      return true;
    }
    // Check anti-diagonal
    if (row + col == 2 &&
        board.every((r) => r[2 - board.indexOf(r)] == currentPlayer)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: _restartGame,
          ),
          IconButton(
            icon: Icon(Icons.refresh_outlined),
            onPressed: _resetScoreboard,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildScoreBoard(),
            _buildBoard(),
            if (winner != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$winner wins!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Player X',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('$xWins', style: TextStyle(fontSize: 24)),
            ],
          ),
          Column(
            children: <Widget>[
              Text('Player O',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('$oWins', style: TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return GestureDetector(
              onTap: () => _makeMove(row, col),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: board[row][col].isEmpty
                      ? Colors.white
                      : (board[row][col] == 'X'
                          ? Colors.blue[100]
                          : Colors.red[100]),
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: board[row][col] == 'X'
                          ? Colors.blue[800]
                          : Colors.red[800],
                    ),
                    child: Text(board[row][col]),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
