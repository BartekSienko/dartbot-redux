// ignore_for_file: file_names
import 'package:dartbot_redux/backend/match_engine/PlayerMatchStats.dart';
import 'package:dartbot_redux/backend/match_engine/dartPlayer.dart';
import 'package:flutter/material.dart';


class StatBox extends StatefulWidget{
  final DartPlayer player1;
  final DartPlayer player2;
  
  const StatBox({
    super.key,
    required this.player1,
    required this.player2,
  });

  @override
  State<StatBox> createState() => _StatBoxState();
  
}

class _StatBoxState extends State<StatBox> {
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

    DartPlayer player;
    if (isLeft) {
      player = player1;
    } else {
      player = player2;
    }

    PlayerMatchStats playerStats = player.stats;

    List<String> stats = ["0.0",
                          "0",
                          playerStats.dartsThrownLeg.toString(),
                          playerStats.getCheckoutSplit()];

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
