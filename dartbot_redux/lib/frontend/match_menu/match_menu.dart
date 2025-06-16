// ignore_for_file: file_names

import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/num_pad.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/scoreboard.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/stat_box.dart';
import 'package:flutter/material.dart';


class MainMenu extends StatefulWidget{
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  MatchEngine matchEngine = MatchEngine(DartPlayer("L. Humphries", 10.0), 
                                        DartPlayer("L. Littler (ENG) (32)", 10.0),
                                        MatchLogic(501, 3, false, 0, true, false));

  @override
  void initState(){
    super.initState();
    DartPlayer player1 = matchEngine.player1;
    DartPlayer player2 = matchEngine.player2;
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;

          return Stack(
            children: [
              Positioned(
                top: 0,
                height: screenHeight * 0.20, // 20% of screen height
                left: 0,
                right: 0,
                child: Scoreboard(matchEngine: matchEngine),
              ),
              Positioned(
                top: screenHeight * 0.21,
                height: screenHeight * 0.15,
                left: 0,
                right: 0,
                child: StatBox(matchEngine: matchEngine),
              ),
              Positioned(
                top: screenHeight * 0.4,
                height: screenHeight * 0.6,
                left: 0,
                right: 0,
                child: NumPad(matchEngine: matchEngine),
              ),
            ],
          );
        },
      ),
    ),
  );
}

}