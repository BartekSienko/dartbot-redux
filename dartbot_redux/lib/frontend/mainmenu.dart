import 'package:dartbot_redux/backend/match_engine/dartPlayer.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/scoreboard.dart';
import 'package:flutter/material.dart';


class MainMenu extends StatefulWidget{
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {


  DartPlayer player1 = DartPlayer("L. Humphries", 10.0);
  DartPlayer player2 = DartPlayer("L. Littler (ENG) (32)", 10.0);

  @override
  void initState(){
    super.initState();
    player1.score = 501;
    player2.score = 321;
    
    player2.dartThrow(180, true, 0);
  }
  



  int playerOrder = 0;

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
        
        body: Column(
            children: [
              Expanded(flex: 20, child: Scoreboard(player1: player1, player2: player2)),
              Expanded(flex: 2, child: Container()),
              //Expanded(flex: 10, child: createLegStats(screenWidth)),
              Expanded(flex: 50, child: Container()),
            ]
          ),
        ),
      );
  }


Widget buildScoreText(String text, double fontSize, Color textColor, Color backgroundColor) {
  return Stack(
    children: [
      
      Positioned.fill(
        child: Column(
          children: [
            Expanded(
              child: Container(color: backgroundColor.withAlpha(230)),
            ),
            Expanded(
              child: Container(color: backgroundColor),
            ),
          ],
        ),
      ),

      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),  // Padding inside container, not outside
        child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          )
    ],
    
  );
}

/**
  Widget createLegStats(double screenWidth) {
    double statFontSize = screenWidth / 60;
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Table(
            border: TableBorder.all(color: Colors.black, width: 0.5), // Full border and cell borders
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              
            },
            children: [ 
              TableRow(children: [buildStatText(playerName, statFontSize, false), Center(child: buildScoreText("Stats", statFontSize))]),
              TableRow(children: [buildStatText("3 Dart Avr.", statFontSize, false), Center(child: buildScoreText(player3DA.toString(), statFontSize))]),
              TableRow(children: [buildStatText("Last Score", statFontSize, false), Center(child: buildScoreText("0", statFontSize))]),
              TableRow(children: [buildStatText("Darts Thrown", statFontSize, false), Center(child: buildScoreText(playerDartThrown.toString(), statFontSize))]),
              TableRow(children: [buildStatText("Checkout Rate", statFontSize, false), Center(child: buildScoreText("8/21", statFontSize))]),
            ]
            )
        ),
        Expanded(flex: 2, child: Container()),
        Expanded(
          flex: 4,
          child: Table(
            border: TableBorder.all(color: Colors.black, width: 0.5), // Full border and cell borders
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              
            },
            children: [ 
              TableRow(children: [Center(child: buildScoreText("Stats", statFontSize)), buildStatText("L. Littler", statFontSize, true)]),
              TableRow(children: [Center(child: buildScoreText("180.0", statFontSize)), buildStatText("3 Dart Avr.", statFontSize, true)]),
              TableRow(children: [Center(child: buildScoreText("180", statFontSize)), buildStatText("Last Score", statFontSize, true)]),
              TableRow(children: [Center(child: buildScoreText("3", statFontSize)), buildStatText("Darts Thrown", statFontSize, true)]),
              TableRow(children: [Center(child: buildScoreText("1/1", statFontSize)), buildStatText("Checkout Rate", statFontSize, true)]),
            ]
            )
        ),
      ],
    );
    
  }
*/

  Widget buildStatText(String text, double fontSize, bool alignRight) {

    return Padding(
      padding: EdgeInsets.all(16), // Adjust padding as needed
      child: Align( 
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize
                      ),
                  )
    )
    );
  }

   // Helper method to center text with padding
  Widget buildScoreText2(String text, double fontSize) {
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