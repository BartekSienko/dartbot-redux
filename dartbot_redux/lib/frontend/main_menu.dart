



import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/frontend/match_menu/match_menu.dart';
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
            Expanded(flex: 20, child: createMenuButton("Quick Match", "Play a quick local match", fontSize, SetupMenu())),
            Expanded(flex: 2, child: Container()),
            Expanded(flex: 20, child: createMenuButton("Tournament", "NOT YET IMPLEMENTED!\nCreate a tournament to play", fontSize, TournamentMenu())),
            Expanded(flex: 2, child: Container()),
            Expanded(flex: 20, child: createMenuButton("Career Mode", "NOT YET IMPLEMENTED!\nPlay out a custom career mode", fontSize, SetupMenu())),
            Expanded(flex: 2, child: Container()),
            Expanded(flex: 20, child: createMenuButton("Profile", "NOT YET IMPLEMENTED!\nLook at your profile and all-time stats", fontSize, MatchMenu(matchEngine: MatchEngine(DartPlayer("Barenko", 100), DartBot("Hugo", 100),
                                                                                                                                                       MatchLogic(301, 3, true, 3, false, false, true), context), 
                                                                                                                                                       matchTitle: "Uppsala Open", matchTheme: MatchTheme("WC")))),
            Expanded(flex: 2, child: Container()),
          ],
        ) 
        
      );
  }
  
  Widget createMenuButton(String menuName, String menuInfo, double fontSize, StatefulWidget pageToLoad) {
    return SizedBox.expand(
    child: Padding(
      padding: const EdgeInsets.all(0.0), // Optional: add spacing inside
      child: ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                                      builder: (context) => pageToLoad,
                                     ),
                    )
                },
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

  

}