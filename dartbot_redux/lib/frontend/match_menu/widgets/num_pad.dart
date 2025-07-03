// ignore_for_file: file_names


import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:flutter/material.dart';

class NumPad extends StatefulWidget{
  final MatchEngine matchEngine;
  final List<Color> matchTheme;
  final double height;

  
  const NumPad({
    super.key,
    required this.matchEngine,
    required this.matchTheme,
    required this.height
  });

  @override
  State<NumPad> createState() => _NumPadState();
  
}

class _NumPadState extends State<NumPad> {
  late MatchEngine matchEngine;
  late List<Color> matchTheme;

  String inputingScore = "";


  @override
  void initState() {
    super.initState();
    matchEngine = widget.matchEngine;
    matchTheme = widget.matchTheme;

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
  
  double fontSize = screenWidth / 30; 
  double numFontSize = fontSize * 2;
  Color numPadTextColor = Colors.white;
  Color numPadBGColor = Colors.black;
  Color themeColor = matchTheme[0];


  return SizedBox(
    height: widget.height, // total height
    child: Column(
  children: [SizedBox(
      height: widget.height * 1 / 5, // Added due to rounding errors
      child: buildTextField(fontSize, numPadTextColor, themeColor),
      ),
      SizedBox(
      height: widget.height * 4 / 5, // Added due to rounding errors
      child: buildNumPad(numFontSize, numPadTextColor, numPadBGColor),
    ),
  ],
)
  );

  }


  Widget buildTextField(double fontSize, Color textColor, Color bGColor) {
      String playerName;
      if (matchEngine.throwing == 1) {
        playerName = matchEngine.player1.name;
      } else {
        playerName = matchEngine.player2.name;
      }
      

      return Container(
    color: matchTheme[1],
    child: Column( children: [ Expanded(
      child: Column(
        children: [
          //Green textbox
            Container(
            color: bGColor,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(fontSize * 0.7),  // Padding inside container, not outside
            child: Text(
                "$playerName turn to throw!",
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),

          Container(
            color: matchTheme[1],
            alignment: Alignment.centerLeft,
            padding:  EdgeInsets.all((fontSize * 0.7)),  // Padding inside container, not outside
            child: Text(
                "Total Score: $inputingScore",
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            )
          ],
      ))]));
  }

  Widget buildNumPad(double fontSize, Color textColor, Color bGColor) {
    

    
    return Container(
    color: Colors.white,
    child: Column( children: [ Expanded(
      child: Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
            TableRow(children: [
              buildNumber("1", fontSize, textColor, bGColor),
              buildNumber("2", fontSize, textColor, bGColor),
              buildNumber("3", fontSize, textColor, bGColor),
            ]
            ),
            TableRow(children: [
              buildNumber("4", fontSize, textColor, bGColor),
              buildNumber("5", fontSize, textColor, bGColor),
              buildNumber("6", fontSize, textColor, bGColor),
            ]
            ),
            TableRow(children: [
              buildNumber("7", fontSize, textColor, bGColor),
              buildNumber("8", fontSize, textColor, bGColor),
              buildNumber("9", fontSize, textColor, bGColor),
            ]
            ),
            TableRow(children: [
              buildNumber("C", fontSize, textColor, bGColor),
              buildNumber("0", fontSize, textColor, bGColor),
              buildNumber(">", fontSize, textColor, bGColor),
            ]
            ),

      ]
    ))]));
  }

  Widget buildNumber(
  String number,
  double fontSize,
  Color textColor,
  Color bGColor,
) {
  double boxHeight = widget.height * 0.2; // 0.5 * 1/4


  return SizedBox(
    height: boxHeight,
    child: TextButton(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(EdgeInsets.zero), // remove default padding
      backgroundColor: WidgetStateProperty.all(bGColor), // base background color
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.zero), // no rounding, adjust as needed
      ),
    ),
    onPressed: () => handleButtonPress(number),
    child: Stack(
      children: [
        Container(color: Colors.white),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: Container(color: bGColor.withAlpha(230)),
              ),
              Expanded(
                child: Container(color: bGColor),
              ),
            ],
          ),
        ),
        Center(
            child: Padding(
              padding: EdgeInsets.all(fontSize / 2), // Optional padding
              child: Text(
                number,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
      ],
    ),
  )
  );
}

void handleButtonPress(String number) {
  if (int.tryParse(number) != null) {
    setState(() {
    inputingScore += number; // update the state variable
    });
  } else if (number == ">") {
    matchEngine.visitThrow(int.tryParse(inputingScore)!);
    inputingScore = "";
  } else if (number == "C") {
    setState(() {
    inputingScore = ""; // update the state variable
    });
  }
}


}