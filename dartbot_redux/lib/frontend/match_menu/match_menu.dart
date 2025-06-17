// ignore_for_file: file_names

import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/num_pad.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/scoreboard.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/stat_box.dart';
import 'package:flutter/material.dart';


class MatchMenu extends StatefulWidget{
  final MatchEngine matchEngine;

  const MatchMenu({super.key, required this.matchEngine});

  @override
  State<MatchMenu> createState() => _MatchMenuState();
}

class _MatchMenuState extends State<MatchMenu> {
  late MatchEngine matchEngine;


  @override
  void initState(){
    super.initState();
    matchEngine = widget.matchEngine;
    matchEngine.initMatch();
  }
  



  int playerOrder = 0;

  @override
Widget build(BuildContext context) {

  return Scaffold(
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
                top: screenHeight * 0.225,
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
  );
    
}

}