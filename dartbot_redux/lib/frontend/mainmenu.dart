import 'package:flutter/material.dart';


class MainMenu extends StatefulWidget{
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  String playerName = "L. Humphries";
  double player3DA = 123.9;
  int playerScore = 501;
  int playerDartThrown = 0;

  double numberFontSize = 12;
  double nameFontSize = 16;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Dartbot Redux'),
          centerTitle: true,
        ),
        
        body: Container(
            child: Table(
            border: TableBorder.all(color: Colors.black, width: 0.5), // Full border and cell borders

            columnWidths: {
              0: FlexColumnWidth(5),
              1: FlexColumnWidth(1.6),
              2: FlexColumnWidth(1.8),
              3: FlexColumnWidth(1.6)
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
               TableRow(children: [
                buildScoreText("Player Name", nameFontSize),
                Center(child: buildScoreText("3DA", numberFontSize)),
                Center(child: buildScoreText("Score", numberFontSize)),
                Center(child: buildScoreText("Darts\nThrown", numberFontSize * 0.6)),
              ]),
                TableRow(children: [
                  buildScoreText(playerName, nameFontSize),
                  Center(child: buildScoreText(player3DA.toString(), numberFontSize * 0.95)),
                  Center(child: buildScoreText(playerScore.toString(), numberFontSize * 1.1)),
                  Center(child: buildScoreText(playerDartThrown.toString(), numberFontSize * 0.95)),
              ]),
              TableRow(children: [
                buildScoreText("L. Littler", nameFontSize),
                Center(child: buildScoreText("180.0", numberFontSize * 0.95)),
                Center(child: buildScoreText("321", numberFontSize* 1.1)),
                Center(child: buildScoreText("3", numberFontSize * 0.95)),
              ]),
            ],
          ),
        ),
      )
    );
  }

   // Helper method to center text with padding
  Widget buildScoreText(String text, double fontSize) {
    return Padding(
      padding: EdgeInsets.all(16), // Adjust padding as needed
      child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize
                      ),
                  )
    );
  }

}