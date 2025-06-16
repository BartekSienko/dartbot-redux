// ignore_for_file: file_names
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/backend/match_engine/player_match_stats.dart';
import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:flutter/material.dart';


class StatBox extends StatefulWidget{
  final MatchEngine matchEngine;
  
  const StatBox({
    super.key,
    required this.matchEngine
  });

  @override
  State<StatBox> createState() => _StatBoxState();
  
}

class _StatBoxState extends State<StatBox> {
  late MatchEngine matchEngine;



  @override
  void initState() {
    super.initState();
    matchEngine = widget.matchEngine;

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


    return Row(
      children: [
        Expanded(flex: 40, child: boxCreate(screenWidth, true)),
        Expanded(flex: 20, child: Container()),
        Expanded(flex: 40, child: boxCreate(screenWidth, false)),
      ],
    );
    
  }

  Widget boxCreate(double screenWidth, bool isLeft) {
    double statFontSize = screenWidth / 40;
    Color textColor = Colors.white;
    Color bGColor = Colors.black;
    Color themeColor = Colors.green;

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
        buildNameText(player.name, statFontSize, textColor, bGColor),
        //Player Stats
        buildStatText(stats, statFontSize, textColor, themeColor, isLeft)
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
        padding: EdgeInsets.all(fontSize * 0.8),  // Padding inside container, not outside
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
    leftText = "3 Dart Avr.\n" "Last Score\n" "Darts Thrown\n" "Checkout Rate";
    rightText = "${stats[0]}\n" "${stats[1]}\n" "${stats[2]}\n" "${stats[3]}";
  } else {
   leftText  = "${stats[0]}\n" "${stats[1]}\n" "${stats[2]}\n" "${stats[3]}";
   rightText = "3 Dart Avr.\n" "Last Score\n" "Darts Thrown\n" "Checkout Rate";
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
        padding: EdgeInsets.all(fontSize * 0.8),  // Padding inside container, not outside
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
        padding: EdgeInsets.all(fontSize * 0.8),  // Padding inside container, not outside
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

}
