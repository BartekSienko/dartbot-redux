// ignore_for_file: file_names


import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:flutter/material.dart';

class NumPad extends StatefulWidget{
  final MatchEngine matchEngine;

  
  const NumPad({
    super.key,
    required this.matchEngine
  });

  @override
  State<NumPad> createState() => _NumPadState();
  
}

class _NumPadState extends State<NumPad> {
  late MatchEngine matchEngine;
  String inputingScore = "";


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
  
  double fontSize = screenWidth / 30; 
  double numFontSize = fontSize * 2;
  Color numPadTextColor = Colors.white;
  Color numPadBGColor = Colors.black;
  Color themeColor = Colors.green;


  return Column(
    children: [

    //Text Field
    buildTextField(fontSize, numPadTextColor, themeColor),
    // NumPad
    buildNumPad(numFontSize, numPadTextColor, numPadBGColor)
    ]
  );
  
  }


  Widget buildTextField(double fontSize, Color textColor, Color bGColor) {
      return Column(
        children: [
          //Green textbox
            Container(
            color: bGColor,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(fontSize * 0.8),  // Padding inside container, not outside
            child: Text(
                "${matchEngine.player1.name} turn to throw!",
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),

          //White "TextField"
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding:  EdgeInsets.all((fontSize * 0.8)),  // Padding inside container, not outside
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
      );
  }

  Widget buildNumPad(double fontSize, Color textColor, Color bGColor) {
    

    
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
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
    );
  }

  Widget buildNumber(
  String number,
  double fontSize,
  Color textColor,
  Color bGColor,
) {
  return TextButton(
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
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(fontSize * 0.87), // inside padding
          child: Text(
            number,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
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