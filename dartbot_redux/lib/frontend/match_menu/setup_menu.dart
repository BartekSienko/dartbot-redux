import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/frontend/match_menu/match_menu.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:flutter/material.dart';

class SetupMenu extends StatefulWidget{
  const SetupMenu({super.key});

  @override
  State<SetupMenu> createState() => _SetupMenuState();
}


class _SetupMenuState extends State<SetupMenu> {
    // Controllers
  final matchTitleController = TextEditingController();
  final matchThemeController = TextEditingController();
  final player1nameController = TextEditingController();
  final player2nameController = TextEditingController();
  final player1ratingController = TextEditingController();
  final player2ratingController = TextEditingController();
  final startScoreController = TextEditingController();
  final legCountController = TextEditingController();
  final setCountController = TextEditingController();


    // Button press tracking variables
  String player1Type = '';
  String player2Type = '';
  String doubleIn = 'Straight-In';
  String doubleOut = 'Straight-Out';

@override
  void dispose() {
    player1nameController.dispose();
    player2nameController.dispose();
    player1ratingController.dispose();
    player2ratingController.dispose();
    startScoreController.dispose();
    legCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('DartBot - Match Setup'), backgroundColor: Colors.green,),
        body: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 207),
              border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
            ),
            child: Column(
            children: [
              Row(
                children: [
                  buildTextWithTextField('Player 1 Name', player1nameController),
                  buildTextWithTextField('Player 2 Name', player2nameController),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  buildTextWithTextField('Player 1 Rating', player1ratingController),
                  buildTextWithTextField('Player 2 Rating', player2ratingController),
                ],
              ),
               SizedBox(height: 24),
               Row(children: [
                buildButtonPair(
                    label1: 'Player',
                    label2: 'Bot',
                    selected1: player1Type,
                    onSelected1: (val) {
                      setState(() {
                        player1Type = val;
                      });
                    },
                  ),
                  buildButtonPair(
                    label1: 'Player',
                    label2: 'Bot',
                    selected1: player2Type,
                    onSelected1: (val) {
                      setState(() {
                        player2Type = val;
                      });
                    },
                  ),]),

            SizedBox(height: 24),
              Row(
                children: [
                  buildTextWithTextField('Match Title', matchTitleController),
                  buildTextWithTextField('Match Theme', matchThemeController),
                  
                ],
              ),

            SizedBox(height: 24),
              Row(
                children: [
                  buildTextWithTextField('Start Score', startScoreController),
                  buildTextWithTextField('Leg Count', legCountController),
                  buildTextWithTextField('Set Count', setCountController),
                  
                ],
              ),

              SizedBox(height: 24),
              buildButtonPair(
                    label1: 'Double-In',
                    label2: 'Straight-In',
                    selected1: doubleIn,
                    onSelected1: (val) {
                      setState(() {
                        doubleIn = val;
                      });
                    },
                  ),
                buildButtonPair(
                    label1: 'Double-Out',
                    label2: 'Straight-Out',
                    selected1: doubleOut,
                    onSelected1: (val) {
                      setState(() {
                        doubleOut = val;
                      });
                    },
                  ),

              SizedBox(height: 240),


              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                    MatchEngine matchEngine = createMatch();
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => MatchMenu(matchTitle: matchTitleController.text, 
                                                    matchTheme: MatchTheme(matchThemeController.text), 
                                                    matchEngine: matchEngine),
                    ),
                    );
                },
                child: Text('Start Match'),
              ),
            ],)
            ),
          );
        
  }


    Widget buildTextWithTextField(String label, TextEditingController controller) {
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                isDense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonPair({
    required String label1,
    required String label2,
    required Function(String) onSelected1,
    required String selected1,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => onSelected1(label1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selected1 == label1 ? Colors.green : Colors.white,
                ),
                child: Text(label1, style: TextStyle(fontSize: 11),),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => onSelected1(label2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selected1 == label2 ? Colors.green : Colors.white,
                ),
                child: Text(label2, style: TextStyle(fontSize: 11),),
              ),
            ),
          ],
        ),
      ),
    );
  }


  MatchEngine createMatch() {
    DartPlayer player1 = DartPlayer(player1nameController.text, 
                                    double.parse(player1ratingController.text));
    DartPlayer player2 = DartPlayer(player2nameController.text, 
                                    double.parse(player2ratingController.text));
    if (player1Type == 'Bot') {
        player1 = DartBot(player1.name, player1.rating);
    }
    if (player2Type == 'Bot') {
        player2 = DartBot(player2.name, player2.rating);
    }
    
    int startScore = int.parse(startScoreController.text);
    int legCount = int.parse(legCountController.text);
    int setCount = int.parse(setCountController.text);
    bool isSetPlay = setCount > 1;
    bool isDoubleIn = doubleIn == "Double-In";
    bool isDoubleOut = doubleOut == "Double-Out";
    

    MatchLogic rules = MatchLogic(startScore, 
               legCount, 
               isSetPlay, setCount, isDoubleOut, isDoubleIn);

    return MatchEngine(player1, player2, rules, context);

  }

  List<Color> getTheme(themeText) {
    Color mainColor;
    Color secondaryColor;
    Color backgroundColor;
    Color mainBoxColor;
    Color nameBoxColor;
    Color mainBoxTextColor;
    Color nameBoxTextColor;
    
    
    if (themeText == 'WC') {
      mainColor = const Color.fromARGB(255, 59, 120, 62); 
      secondaryColor = const Color.fromARGB(255, 190, 190, 51);
      backgroundColor = const Color.fromARGB(255, 30, 52, 31);
      mainBoxColor = const Color.fromARGB(255, 59, 120, 62); 
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Masters') {
      mainColor = Colors.purple;
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 89, 22, 101);
      mainBoxColor = Colors.purple;
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'UK') {
      mainColor = Colors.red; 
      secondaryColor = const Color.fromARGB(255,255,255,255);
      backgroundColor = const Color.fromARGB(255, 24, 40, 92);
      mainBoxColor = const Color.fromARGB(255, 44, 71, 158); 
      nameBoxColor = const Color.fromARGB(255, 255, 255, 255);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Matchplay') {
      mainColor = const Color.fromARGB(255, 59, 120, 62); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 30, 52, 31);
      mainBoxColor = const Color.fromARGB(255, 59, 120, 62); 
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'GrandPrix') {
      mainColor = const Color.fromARGB(255, 44, 71, 158); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 24, 40, 92);
      mainBoxColor = const Color.fromARGB(255, 44, 71, 158); 
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'GrandSlam') {
      mainColor = const Color.fromARGB(255, 59, 120, 62); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 30, 52, 31);
      mainBoxColor = const Color.fromARGB(255, 165, 165, 44);
      nameBoxColor = const Color.fromARGB(255, 255, 255, 255); 
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Euro') {
      mainColor = const Color.fromARGB(255, 44, 71, 158); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 24, 40, 92);
      mainBoxColor = const Color.fromARGB(255, 44, 71, 158); 
      nameBoxColor = const Color.fromARGB(255, 87, 103, 158);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 255, 255, 255);

    } else if (themeText == 'Euro+') {
      mainColor = const Color.fromARGB(255, 44, 71, 158); 
      secondaryColor = const Color.fromARGB(255, 190, 190, 51);
      backgroundColor = const Color.fromARGB(255, 24, 40, 92);
      mainBoxColor = const Color.fromARGB(255, 44, 71, 158); 
      nameBoxColor = const Color.fromARGB(255, 87, 103, 158);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 255, 255, 255);

    } else if (themeText == 'PC') {
      mainColor = Colors.red; 
      secondaryColor = const Color.fromARGB(255,255,255,255);
      backgroundColor = const Color.fromARGB(255, 80, 0, 0);
      mainBoxColor = const Color.fromARGB(255, 0, 0, 0);
      nameBoxColor = const Color.fromARGB(255, 255, 255, 255);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'PC+') {
      mainColor = Colors.red; 
      secondaryColor = const Color.fromARGB(255,255,255,255);
      backgroundColor = const Color.fromARGB(255, 80, 0, 0);
      mainBoxColor = const Color.fromARGB(255, 150, 0, 0);
      nameBoxColor = const Color.fromARGB(255, 255, 255, 255);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Prem') {
      mainColor = const Color.fromARGB(255, 59, 120, 62); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 89, 22, 101);
      mainBoxColor = Colors.purple;
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Reg') {
      mainColor = Colors.cyan;
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 53, 117, 125);
      mainBoxColor = Colors.cyan;
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else { // default values
      mainColor = Colors.green; 
      secondaryColor = Colors.white;
      backgroundColor = const Color.fromARGB(255, 47, 83, 49);
      mainBoxColor = Colors.green; 
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);
    }


    return [mainColor, secondaryColor, backgroundColor, 
            mainBoxColor, nameBoxColor, mainBoxTextColor, nameBoxTextColor];
  }



}