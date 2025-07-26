// ignore_for_file: file_names
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/backend/match_engine/player_match_stats.dart';
import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:flutter/material.dart';


class StatBox extends StatefulWidget{
  final MatchEngine matchEngine;
  final MatchTheme matchTheme;
  final double height;
  final VoidCallback onReload;

  
  const StatBox({
    super.key,
    required this.matchEngine,
    required this.matchTheme,
    required this.onReload,
    required this.height
  });

  @override
  State<StatBox> createState() => _StatBoxState();
  
}

class _StatBoxState extends State<StatBox> {
  late MatchEngine matchEngine;
  late MatchTheme matchTheme;
  late VoidCallback onReload;

  late double height;



  @override
  void initState() {
    super.initState();
    matchEngine = widget.matchEngine;
    matchTheme = widget.matchTheme;
    onReload = widget.onReload;


    matchEngine.addListener(_onMatchEngineUpdate);  

  }

      @override
  void dispose() {
    matchEngine.removeListener(_onMatchEngineUpdate);
    super.dispose();
  }

  void _onMatchEngineUpdate() {
    setState(() {
      // Rebuild the widget whenever MatchEngine notifies
    });
  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;


    return SizedBox(
    height: widget.height,
    child: Row(
      children: [
        Expanded(flex: 40, child: boxCreate(screenWidth, true)),
        Expanded(flex: 20, child: buildStatAndSimButtons(screenWidth)),
        Expanded(flex: 40, child: boxCreate(screenWidth, false)),
      ],
    )
    );
    
  }

  Widget boxCreate(double screenWidth, bool isLeft) {
    double statFontSize = screenWidth / 35;
    Color textColor = matchTheme.mainBoxTextColor;
    Color bGColor = Colors.black;
    Color themeColor = matchTheme.mainColor;

    DartPlayer player1 = matchEngine.player1;
    DartPlayer player2 = matchEngine.player2;

    DartPlayer player;
    if (isLeft) {
      player = player1;
    } else {
      player = player2;
    }

    PlayerMatchStats playerStats = player.stats;

    String average = playerStats.getListAverage(playerStats.scores).toString();
    String last;
    if (playerStats.scores.isEmpty) {
      last = "0";
    } else {
      last = playerStats.scores.last.toString();
    }
    String dartsThrown = playerStats.dartsThrownLeg.toString();
    String checkouts = playerStats.getCheckoutSplit();

    List<String> stats = [average, last, dartsThrown, checkouts];


    return Column(
      
      children: [
        // Player Name
        Expanded(flex: 25, child: buildNameText(player.name, statFontSize, textColor, bGColor)),
        //Player Stats
        Expanded(flex: 75, child: buildStatText(stats, statFontSize, textColor, themeColor, isLeft))
      ],
      );
  }

  Widget buildNameText(String text, double fontSize, Color textColor, Color backgroundColor) {
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
        padding: EdgeInsets.all(fontSize / 2),  // Padding inside container, not outside
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


Widget buildStatText(List<String> stats, double fontSize, Color textColor, Color backgroundColor, bool isLeft) {
  String leftText;
  String rightText;
  int leftFlex = 3;
  int rightFlex = 2;
  Color leftColor = backgroundColor;
  Color rightColor = backgroundColor.withAlpha(230);
  if (isLeft) {
    leftText = "3 Dart Avr.\n" "Last Score\n" "Darts Thrown\n" "Checkouts";
    rightText = "${stats[0]}\n" "${stats[1]}\n" "${stats[2]}\n" "${stats[3]}";
  } else {
   leftText  = "${stats[0]}\n" "${stats[1]}\n" "${stats[2]}\n" "${stats[3]}";
   rightText = "3 Dart Avr.\n" "Last Score\n" "Darts Thrown\n" "Checkouts";
   leftFlex--;
   rightFlex++;
   leftColor = rightColor;
   rightColor = backgroundColor;
  }

  
  
  return Row(
    children: [
      // Textside
      Expanded(
      flex: leftFlex,
      child: Container(
        color: leftColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(fontSize / 2),  // Padding inside container, not outside
        child: Text(
            leftText,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
            textAlign: TextAlign.right,
          ),
        )),
      // Stat
      Expanded(
      flex: rightFlex,
      child: Container(
        color: rightColor,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(fontSize / 2),  // Padding inside container, not outside
        child: Text(
            rightText,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
            textAlign: TextAlign.left,
          ),
        ))
    ],
  );
}

  Widget buildStatAndSimButtons(double screenWidth) {
    double fontSize = screenWidth / 35;

    return Column(
      children: [  
        // Stat Button
        Expanded(
          flex: 50, 
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0,
                                                  vertical: 12.0),
            child: buildButton("Match\n Stats",
                              fontSize,
                              () {
                                matchEngine.showMatchStats(context, false);
                              })                             
          ),
        ),
        Expanded(
          flex: 50, 
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0,
                                                  vertical: 12.0),
            child: buildButton("Sim\nPortion",
                              fontSize,
                              () {
                                simMatchPortionDialog();
                              })                             
          ),
        ),
      ]
    );
  }


  Widget buildButton(
    String label,
    double fontSize,
    Function() onPressed
  ) {
    return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: matchTheme.mainBoxColor,
            minimumSize: Size(double.infinity, fontSize * 3), // Ensures button doesn't force a size
            padding: EdgeInsets.all(6.0), // Optional: tighten button space
          ),
          
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            
            child: Center(
              child: Text(label, style: TextStyle(fontSize: fontSize, color: matchTheme.mainBoxTextColor),))
            )
        );

  }

  void simMatchPortionDialog() {

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      double height = MediaQuery.of(dialogContext).size.height;


      return AlertDialog(
        backgroundColor: matchTheme.secondaryColor,
        title: const Center(child: Text('How much to sim?')),
        content: Column(
          mainAxisSize: MainAxisSize.min, // important for sizing
          children: [
            buildButton(
              "Sim 1 Leg",
              16,
              () {
                matchEngine.simPortion(1, 'leg');
                Navigator.of(dialogContext).pop();
                onReload();

                if (matchEngine.matchRules.isSetPlay) {
                  matchEngine.checkForFinishedSet(true);
                }
                matchEngine.checkForMatchWinner(matchEngine.player1, 1, true);
                matchEngine.checkForMatchWinner(matchEngine.player2, 2, true);
              },
            ),
            if (matchEngine.matchRules.isSetPlay)... [

            SizedBox(height: height / 150, child: Container(color: matchTheme.secondaryColor),),
            buildButton(
              "Sim 1 Set",
              16,
              () {
                matchEngine.simPortion(1, 'set');
                Navigator.of(dialogContext).pop();
                onReload();
                matchEngine.checkForMatchWinner(matchEngine.player1, 1, true);
                matchEngine.checkForMatchWinner(matchEngine.player2, 2, true);
                
              },
            ),          
            ],
            SizedBox(height: height / 150, child: Container(color: matchTheme.secondaryColor),),
            buildButton(
              "Sim Match",
              16,
              () {
                matchEngine.simPortion(1, 'match');
                Navigator.of(dialogContext).pop();
                onReload();
                matchEngine.checkForMatchWinner(matchEngine.player1, 1, true);
                matchEngine.checkForMatchWinner(matchEngine.player2, 2, true);

              },
            ),
            SizedBox(height: height / 150, child: Container(color: matchTheme.secondaryColor),),
            buildButton(
              "Go Back",
              16,
              () {
                Navigator.of(dialogContext).pop();
              },
            )
            
          ],
        ),
      );
    },
  );
  }


}
