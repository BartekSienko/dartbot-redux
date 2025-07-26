




import 'package:dartbot_redux/backend/file_management/json_manager.dart';
import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/backend/tournaments/tournament.dart';
import 'package:dartbot_redux/frontend/match_menu/setup_menu.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:dartbot_redux/frontend/tournament_menu/tournament_menu.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget{



  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}


class _MainMenuState extends State<MainMenu> {
  Tournament? _tournament;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenHeight / 30;
     return Scaffold(
        appBar: AppBar(title: Text('DartBot Redux', textAlign: TextAlign.center), backgroundColor: Color.fromARGB(255, 240, 240, 207)),
        backgroundColor: Colors.green,
        body: Column (
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(flex: 20, child: createMenuButton("Quick Match", "Play a quick local match", fontSize, () => Navigator.push(
                                                                                                                                  context,
                                                                                                                                  MaterialPageRoute(builder: (context) => SetupMenu()),
                                                                                                                                ),)),
            Expanded(flex: 2, child: Container()),
            Expanded(flex: 20, child: createMenuButton("Tournament", "NOT YET IMPLEMENTED!\nCreate a tournament to play", fontSize, () async {
                // ignore: prefer_conditional_assignment
                if (_tournament == null) {
                  try {
                  _tournament = await JsonManager().loadTournamentFromFile("World Grand Prix");
                  } on Exception {
                    _tournament = genTournament();
                  } 
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TournamentMenu(tournament: _tournament!),
                  ),
                );
              },)),
            Expanded(flex: 2, child: Container()),
            Expanded(flex: 20, child: createMenuButton("Career Mode", "NOT YET IMPLEMENTED!\nPlay out a custom career mode", fontSize, () => ())),
            Expanded(flex: 2, child: Container()),
            Expanded(flex: 20, child: createMenuButton("Profile", "NOT YET IMPLEMENTED!\nLook at your profile and all-time stats", fontSize, () => ())),
            Expanded(flex: 2, child: Container()),
          ],
        ) 
        
      );
  }
  
  Widget createMenuButton(String menuName, 
                          String menuInfo, 
                          double fontSize, 
                          VoidCallback onPressed) {
    return SizedBox.expand(
    child: Padding(
      padding: const EdgeInsets.all(0.0), // Optional: add spacing inside
      child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.zero, // Important: remove default padding
                ),
                //child: Text(menuName, style: TextStyle(fontSize: 11),),
                child: Center( 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(menuName, style: TextStyle(fontSize: fontSize),),
                      Text("-----------------------", style: TextStyle(fontSize: fontSize)),
                      Text(menuInfo, style: TextStyle(fontSize: fontSize * 0.5),)
                    ],
                  )
                )
            )
    )
    );
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