import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:flutter/material.dart';


class Scoreboard extends StatefulWidget{
  final MatchEngine matchEngine;
  
  const Scoreboard({
    super.key,
    required this.matchEngine
  });

  @override
  State<Scoreboard> createState() => _ScoreboardState();
  
}

class _ScoreboardState extends State<Scoreboard> {
  late MatchEngine matchEngine;


  @override
void initState() {
  super.initState();
  matchEngine = widget.matchEngine;

  // Add listener to rebuild the widget when MatchEngine notifies
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
  
  DartPlayer player1 = matchEngine.player1;
  DartPlayer player2 = matchEngine.player2;
  
  
  
  double nameFontSize = screenWidth / 28;
  double numberFontSize = screenWidth / 28;
  Color topRowTextColor = Colors.white;
  Color topRowBGColor = Colors.black;
  Color nameTextColor = Colors.black;
  Color nameBGColor = Colors.white;
  Color numberTextColor = Colors.white;
  Color numberBGColor = Colors.green;

  return Table(
          columnWidths: {
            0: FlexColumnWidth(6),
            1: FlexColumnWidth(1.95),
            2: FlexColumnWidth(1.95),
            3: FlexColumnWidth(2.1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              buildScoreText("First to 3 Legs", nameFontSize, topRowTextColor, topRowBGColor),
              buildScoreText("Sets", nameFontSize, topRowTextColor, topRowBGColor),
              buildScoreText("Legs", nameFontSize, topRowTextColor, topRowBGColor),
              buildScoreText("Score", nameFontSize, topRowTextColor, topRowBGColor),
            ]),
            TableRow(children: [
              buildScoreText(player1.name, nameFontSize, nameTextColor, nameBGColor),
              buildScoreText(player1.sets.toString(), numberFontSize, numberTextColor, numberBGColor),
              buildScoreText(player1.legs.toString(), numberFontSize, numberTextColor, numberBGColor),
              buildScoreText(player1.score.toString(), numberFontSize, numberTextColor, numberBGColor),
          ]),
            TableRow(children: [
              buildScoreText(player2.name, nameFontSize, nameTextColor, nameBGColor),
              buildScoreText(player2.sets.toString(), numberFontSize, numberTextColor, numberBGColor),
              buildScoreText(player2.legs.toString(), numberFontSize, numberTextColor, numberBGColor),
              buildScoreText(player2.score.toString(), numberFontSize, numberTextColor, numberBGColor),
          ]),
          ],
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
        padding: EdgeInsets.all(fontSize),  // Padding inside container, not outside
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

}