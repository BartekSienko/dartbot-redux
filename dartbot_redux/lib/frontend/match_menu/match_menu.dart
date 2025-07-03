// ignore_for_file: file_names

import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/num_pad.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/scoreboard.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/stat_box.dart';
import 'package:flutter/material.dart';


class MatchMenu extends StatefulWidget{
  final MatchEngine matchEngine;
  final String matchTitle;
  final List<Color> matchTheme;

  const MatchMenu({super.key, 
                   required this.matchEngine,
                   required this.matchTitle,
                   required this.matchTheme});

  @override
  State<MatchMenu> createState() => _MatchMenuState();
}

class _MatchMenuState extends State<MatchMenu> {
  late MatchEngine matchEngine;
  late String matchTitle;
  late List<Color> matchTheme;

  @override
  void initState(){
    super.initState();
    matchEngine = widget.matchEngine;
    matchTitle = widget.matchTitle;
    matchTheme = widget.matchTheme;
    matchEngine.initMatch();
  }
  



  int playerOrder = 0;

  @override
  Widget build(BuildContext context) {

  return Scaffold(
      backgroundColor: matchTheme[2],
      appBar: AppBar(
        backgroundColor: matchTheme[0],
        title: Text(matchTitle, style: TextStyle(color: matchTheme[1], fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;

          return Stack(
            children: [
              Positioned(
                top: 0,
                height: screenHeight * 0.21, // 20% of screen height
                left: 0,
                right: 0,
                child: Scoreboard(matchEngine: matchEngine,
                                  matchTheme: matchTheme,
                                  height: screenHeight * 0.21),
              ),
              Positioned(
                top: screenHeight * 0.23,
                height: screenHeight * 0.2,
                left: 0,
                right: 0,
                child: StatBox(matchEngine: matchEngine,
                               matchTheme: matchTheme,
                               height: screenHeight * 0.2),
              ),
              Positioned(
                top: screenHeight * 0.45,
                height: screenHeight * 0.55,
                left: 0,
                right: 0,
                child: NumPad(matchEngine: matchEngine,
                              matchTheme: matchTheme,
                              height: screenHeight * 0.55),
              ),
            ],
          );
        },
      ),
  );
  

}

  

}