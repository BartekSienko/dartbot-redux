// ignore_for_file: file_names

import 'package:dartbot_redux/backend/match_engine/dartPlayer.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/numPad.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/scoreboard.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/statBox.dart';
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
    player2.legs = 1;
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
              Expanded(flex: 1, child: Container()),
              Expanded(flex: 15, child: StatBox(player1: player1, player2: player2)),
              Expanded(flex: 1, child: Container()),
              Expanded(flex: 50, child: NumPad(player1: player1, player2: player2))
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