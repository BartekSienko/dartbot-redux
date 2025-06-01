import 'package:flutter/material.dart';


class MainMenu extends StatefulWidget{
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  String playerName = "L. Humphries";
  String natCode = " (ENG)";
  double player3DA = 123.9;
  int playerScore = 501;
  int playerDartThrown = 0;



  int playerOrder = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Dartbot Redux'),
          centerTitle: true,
        ),
        
        body: Column(
            children: [
              Expanded(flex: 20, child: createScoreboard(screenWidth)),
              Expanded(flex: 5, child: Container()),
              Expanded(flex: 20, child: createLegStats(screenWidth)),
              Expanded(flex: 50, child: Container()),
            ]
          ),
        ),
      );
  }


  Widget createScoreboard(double screenWidth) {
    double nameFontSize = screenWidth / 30;
    double numberFontSize = screenWidth / 30;
    return Row(
      children: [
        Expanded(flex: 95,
          child: Table(
            border: TableBorder.all(color: Colors.black, width: 0.5), // Full border and cell borders

            columnWidths: {
              0: FlexColumnWidth(6),
              1: FlexColumnWidth(1.8),
              2: FlexColumnWidth(1.8),
              3: FlexColumnWidth(2.4)
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
               TableRow(children: [
                buildScoreText("First to 3 Legs", nameFontSize),
                Center(child: buildScoreText("Sets", nameFontSize * 0.75)),
                Center(child: buildScoreText("Legs", nameFontSize * 0.70)),
                Center(child: buildScoreText("Score", nameFontSize)),
              ]),
                TableRow(children: [
                  buildScoreText(playerName + natCode, nameFontSize),
                  Center(child: buildScoreText("0", numberFontSize)),
                  Center(child: buildScoreText("2", numberFontSize )),
                  Center(child: buildScoreText("501", numberFontSize)),
              ]),
              TableRow(children: [
                buildScoreText("L. Littler (ENG) (32)", nameFontSize),
                Center(child: buildScoreText("0", numberFontSize)),
                Center(child: buildScoreText("1", numberFontSize)),
                Center(child: buildScoreText("321", numberFontSize)),
              ]),
            ],
          )
        ),
        Expanded(
          flex: 5, 
          child: FractionalTranslation(translation: Offset(0, 5/3 * playerOrder), 
            child: Align(
            alignment: Alignment.centerLeft,
            child: Text(" <", style: TextStyle(fontSize: numberFontSize * 1.5),))))
      ]
    );
    
  }


  Widget createLegStats(double screenWidth) {
    double statFontSize = screenWidth / 60;
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Table(
            border: TableBorder.all(color: Colors.black, width: 0.5), // Full border and cell borders
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              
            },
            children: [ 
              TableRow(children: [buildStatText(playerName, statFontSize, false), Center(child: buildScoreText("Stats", statFontSize))]),
              TableRow(children: [buildStatText("3 Dart Avr.", statFontSize, false), Center(child: buildScoreText(player3DA.toString(), statFontSize))]),
              TableRow(children: [buildStatText("Last Score", statFontSize, false), Center(child: buildScoreText("0", statFontSize))]),
              TableRow(children: [buildStatText("Darts Thrown", statFontSize, false), Center(child: buildScoreText(playerDartThrown.toString(), statFontSize))]),
              TableRow(children: [buildStatText("Checkout Rate", statFontSize, false), Center(child: buildScoreText("8/21", statFontSize))]),
            ]
            )
        ),
        Expanded(flex: 2, child: Container()),
        Expanded(
          flex: 4,
          child: Table(
            border: TableBorder.all(color: Colors.black, width: 0.5), // Full border and cell borders
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              
            },
            children: [ 
              TableRow(children: [Center(child: buildScoreText("Stats", statFontSize)), buildStatText("L. Littler", statFontSize, true)]),
              TableRow(children: [Center(child: buildScoreText("180.0", statFontSize)), buildStatText("3 Dart Avr.", statFontSize, true)]),
              TableRow(children: [Center(child: buildScoreText("180", statFontSize)), buildStatText("Last Score", statFontSize, true)]),
              TableRow(children: [Center(child: buildScoreText("3", statFontSize)), buildStatText("Darts Thrown", statFontSize, true)]),
              TableRow(children: [Center(child: buildScoreText("1/1", statFontSize)), buildStatText("Checkout Rate", statFontSize, true)]),
            ]
            )
        ),
      ],
    );
    
  }


  Widget buildStatText(String text, double fontSize, bool alignRight) {

    return Padding(
      padding: EdgeInsets.all(16), // Adjust padding as needed
      child: Align( 
        alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize
                      ),
                  )
    )
    );
  }

   // Helper method to center text with padding
  Widget buildScoreText(String text, double fontSize) {
    return Padding(
      padding: EdgeInsets.all(16), // Adjust padding as needed
      child: Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize
                      ),
                  )
    );
  }

}