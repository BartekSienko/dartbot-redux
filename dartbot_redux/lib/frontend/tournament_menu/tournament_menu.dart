// ignore_for_file: file_names

import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:dartbot_redux/frontend/tournament_menu/widgets/info_box.dart';
import 'package:flutter/material.dart';


class TournamentMenu extends StatefulWidget{
  

  const TournamentMenu({super.key});

  @override
  State<TournamentMenu> createState() => _TournamentMenuState();
}

class _TournamentMenuState extends State<TournamentMenu> {
  MatchTheme matchTheme = MatchTheme('GrandPrix');

  

  @override
  void initState(){
    super.initState();
  }
  



  int playerOrder = 0;

  @override
  Widget build(BuildContext context) {

  return Scaffold(
      backgroundColor: matchTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: matchTheme.mainColor,
        title: Text("World Grand Prix", style: TextStyle(color: matchTheme.secondaryColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;

          return Stack(
            children: [
              Positioned(
                top: 0,
                height: screenHeight * 0.15, // 20% of screen height
                left: 0,
                right: 0,
                child: InfoBox(matchTheme: matchTheme, 
                               height: screenHeight * 0.15),
              ),
            ],
          );
        },
      ),
  );
  

}

  

}