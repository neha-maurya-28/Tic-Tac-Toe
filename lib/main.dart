import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "TIC TAC TOE",
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.indigo.shade50,
        body: SafeArea(child: TicTacToeGame()),
      ),
    ),
  );
}

class PlayerPanel extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Container(
      child: Card(
        color: Colors.indigo,
        elevation: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerNamePanel("Player A", "X"),
            PlayerNamePanel("Player B", "O"),
          ],
        ),
      ),
    );
  }
}

class PlayerNamePanel extends StatefulWidget {
  String initialName = "";
  String initialSymbol = "";
  PlayerNamePanel(String name, String symbol) {
    initialName = name;
    initialSymbol = symbol;
  }
  @override
  State<PlayerNamePanel> createState() {
    return PlayerNamePanelState();
  }
}

class PlayerNamePanelState extends State<PlayerNamePanel> {
  String playerName = "Player A";
  String buttonText = "edit";
  String playerSymbol = "X";
  @override
  initState() {
    super.initState();
    playerName = widget.initialName;
    playerSymbol = widget.initialSymbol;
  }

  TextEditingController textController = TextEditingController();
  onEditName() {
    setState(() {
      if (buttonText == "edit") {
        buttonText = "save";
      } else {
        playerName = textController.text;
        buttonText = "edit";
      }
    });
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      // height: 110,
      width: 201,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.blueAccent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buttonText == "edit"
                ? Text(
                  playerName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
                : TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: "Enter Name",
                    border: OutlineInputBorder(),
                  ),
                ),
            Text(
              playerSymbol,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(onPressed: onEditName, child: Text(buttonText)),
          ],
        ),
      ),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String winner = '';

  void handleTap(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = currentPlayer;
        if (checkWinner()) {
          winner = currentPlayer;
        } else if (!board.contains('')) {
          winner = 'draw';
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    return winPatterns.any(
      (pattern) =>
          board[pattern[0]] == currentPlayer &&
          board[pattern[1]] == currentPlayer &&
          board[pattern[2]] == currentPlayer,
    );
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        PlayerPanel(),
        SizedBox(height: 20),

        // Center the board and bottom controls horizontally
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Game board
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => handleTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              board[index],
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color:
                                    board[index] == 'X'
                                        ? Colors.indigo
                                        : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  winner == 'draw'
                      ? "It's a Draw!"
                      : winner != ''
                      ? "$winner Wins!"
                      : "Current Turn: $currentPlayer",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: resetGame,
                  child: Text("Reset Game"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
