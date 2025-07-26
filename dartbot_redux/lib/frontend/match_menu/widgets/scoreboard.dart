import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:flutter/material.dart';


class Scoreboard extends StatefulWidget{
  final MatchEngine matchEngine;
  final MatchTheme matchTheme;
  final double height;
  final VoidCallback onReload;
  
  const Scoreboard({
    super.key,
    required this.matchEngine,
    required this.matchTheme,
    required this.height,
    required this.onReload
  });

  @override
  State<Scoreboard> createState() => _ScoreboardState();
  
}

class _ScoreboardState extends State<Scoreboard> {
  late MatchEngine matchEngine;
  late MatchTheme matchTheme;
  late double height;
  late VoidCallback onReload;

  @override
void initState() {
  super.initState();
  matchEngine = widget.matchEngine;
  matchTheme = widget.matchTheme;
  onReload = widget.onReload;

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
  
  
  
  double nameFontSize = screenWidth / 24;
  double numberFontSize = screenWidth / 25;
  Color topRowTextColor = Colors.white;
  Color topRowBGColor = Colors.black;
  Color numberBGColor = matchTheme.mainBoxColor;
  Color numberTextColor = matchTheme.mainBoxTextColor;
  Color nameBGColor = matchTheme.nameBoxColor;
  Color nameTextColor = matchTheme.nameBoxTextColor;
  
  


  String matchDecider = "";
  if (matchEngine.matchRules.isSetPlay) {
    matchDecider = "First to ${matchEngine.matchRules.setLimit} Sets";
  } else {
    matchDecider = "First to ${matchEngine.matchRules.legLimit} Legs";
  }


  return Container(
    color: Colors.white,
    child: Column(
  children: [ Expanded( 
      child: Table(
          columnWidths: {
            0: FlexColumnWidth(6),
            1: FlexColumnWidth(1.95),
            2: FlexColumnWidth(1.95),
            3: FlexColumnWidth(2.1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              buildScoreText(matchDecider, nameFontSize, topRowTextColor, topRowBGColor),
              if (matchEngine.matchRules.isSetPlay) buildScoreText("Sets", nameFontSize, topRowTextColor, topRowBGColor),
              buildScoreText("Legs", nameFontSize, topRowTextColor, topRowBGColor),
              buildScoreText("Score", nameFontSize, topRowTextColor, topRowBGColor),
            ]),
            TableRow(children: [
              buildScoreText(player1.name, nameFontSize, nameTextColor, nameBGColor),
              if (matchEngine.matchRules.isSetPlay) buildScoreText(player1.sets.toString(), numberFontSize, numberTextColor, numberBGColor),
              buildScoreText(player1.legs.toString(), numberFontSize, numberTextColor, numberBGColor),
              buildScoreText(player1.score.toString(), numberFontSize, numberTextColor, numberBGColor),
          ]),
            TableRow(children: [
              buildScoreText(player2.name, nameFontSize, nameTextColor, nameBGColor),
              if (matchEngine.matchRules.isSetPlay) buildScoreText(player2.sets.toString(), numberFontSize, numberTextColor, numberBGColor),
              buildScoreText(player2.legs.toString(), numberFontSize, numberTextColor, numberBGColor),
              buildScoreText(player2.score.toString(), numberFontSize, numberTextColor, numberBGColor),
          ]),
          ],
        )
  )]
    )
  );
  }

Widget buildScoreText(String text, double fontSize, Color textColor, Color backgroundColor) {
  double tableHeight = widget.height / 3; // 1/3 * 0.24 = 0.08

  double adjustedFontSize = fontSize;

  if ((text.length > 16 && matchEngine.matchRules.isSetPlay) || text.length > 23) {
    adjustedFontSize = adjustedFontSize * 0.75;
  }


  return LayoutBuilder(
    builder: (context, constraints) {
      
      return SizedBox(
    height: tableHeight,  // or any fixed height you want
    child: Stack(
        children: [
          // Two-tone background, fills entire cell
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(color: backgroundColor.withAlpha(230)), // top half
                ),
                Expanded(
                  child: Container(color: backgroundColor), // bottom half
                ),
              ],
            ),
          ),

          // Centered text
          Center(
            child: Padding(
              padding: EdgeInsets.all(adjustedFontSize / 2), // Optional padding
              child: Text(
                text,
                style: TextStyle(
                  fontSize: adjustedFontSize,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      )
      );
    },
  );
}

}