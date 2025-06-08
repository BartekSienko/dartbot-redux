import 'package:dartbot_redux/backend/match_engine/dartPlayer.dart';
import 'package:flutter/material.dart';


class Scoreboard extends StatefulWidget{
  final DartPlayer player1;
  final DartPlayer player2;
  
  const Scoreboard({
    super.key,
    required this.player1,
    required this.player2,
  });

  @override
  State<Scoreboard> createState() => _ScoreboardState();
  
}

class _ScoreboardState extends State<Scoreboard> {
  late DartPlayer player1;
  late DartPlayer player2;


  @override
  void initState() {
    super.initState();
    player1 = widget.player1;
    player2 = widget.player2;
  }
  
  @override
  Widget build(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  
  
  
  double nameFontSize = screenWidth / 30;
  double numberFontSize = screenWidth / 30;
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
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
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
        padding: const EdgeInsets.all(16),  // Padding inside container, not outside
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