// ignore_for_file: file_names

import 'package:dartbot_redux/backend/file_management/json_manager.dart';
import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/backend/tournaments/tournament.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:dartbot_redux/frontend/tournament_menu/widgets/info_box.dart';
import 'package:dartbot_redux/frontend/tournament_menu/widgets/match_box.dart';
import 'package:dartbot_redux/frontend/tournament_menu/widgets/player_box.dart';
import 'package:flutter/material.dart';


class TournamentMenu extends StatefulWidget{
  final Tournament tournament;

  const TournamentMenu({super.key, required this.tournament});

  @override
  State<TournamentMenu> createState() => _TournamentMenuState();
}

class _TournamentMenuState extends State<TournamentMenu> {
  late MatchTheme matchTheme;
  late Tournament tournament;
  

  @override
  void initState() {
    super.initState();
    tournament = widget.tournament;
    matchTheme = tournament.matchTheme;
  }
  



  int playerOrder = 0;

  @override
  Widget build(BuildContext context) {
    if (tournament.rounds.isEmpty) {
      tournament.rounds.add(tournament.generateRound());
      JsonManager jsonMan = JsonManager();
      jsonMan.saveTournament(tournament);
    }

  return Scaffold(
      backgroundColor: matchTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: matchTheme.mainColor,
        title: Text(tournament.name, style: TextStyle(color: matchTheme.secondaryColor, fontWeight: FontWeight.bold)),
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
                               tournament: tournament,  
                               height: screenHeight * 0.15),
              ),

              Positioned(
                top: screenHeight * 0.20,
                height: screenHeight * 0.60, // 20% of screen height
                left: 0,
                right: 0,
                child: MatchBox(matchTheme: matchTheme,
                                tournament: tournament,  
                                height: screenHeight * 0.60,
                                onReload: () {
                                  setState(() {});
                                }),
              ),
              
              Positioned(
                top: screenHeight * 0.85,
                height: screenHeight * 0.15, // 20% of screen height
                left: 0,
                right: 0,
                child: PlayerBox(matchTheme: matchTheme,
                                tournament: tournament,
                                height: screenHeight * 0.15,
                                onReload: () {
                                  setState(() {});
                                }),
              ),
            ],
          );
        },
      ),
  );
  

}

  Future<Tournament> genTournamentFromFile() async {
    JsonManager jsonMan = JsonManager();
    return await jsonMan.loadTournamentFromFile("World Grand Prix.json");
  }

  //TODO: Stub function while testing on a already existing Tournament
  Tournament genTournament(){
  List<DartPlayer> round1 = [DartPlayer("N. Aspinall", 12),
                             DartPlayer("R. Cross", 12),
                             DartPlayer("S. Bunting", 13),
                             DartPlayer("J. Clayton", 13)];
  List<DartPlayer> round2 = [DartPlayer("L. Littler", 15),
                             DartPlayer("G. Price", 14)]; 
  List<DartPlayer> round3 = [DartPlayer("L. Humphries", 15),
                             DartPlayer("M. van Gerwen", 14)]; 

  List<List<DartPlayer>> players = [round1, round2, round3];



  MatchLogic rules1 = MatchLogic(301, 6, false, 0, false, false, false);
  MatchLogic rules2 = MatchLogic(301, 8, false, 0, false, false, false);
  List<MatchLogic> rulesets = [rules1, rules1, rules2, rules2];

  List<int> prizeMoney = [120, 60, 40, 25, 12, 8];

  return Tournament("World Grand Prix", "GrandPrix", MatchTheme('GrandPrix'), 8, players, rulesets, prizeMoney, "M. De Decker");
  }

}