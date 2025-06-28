import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/frontend/match_menu/match_menu.dart';
import 'package:flutter/material.dart';

class SetupMenu extends StatefulWidget{
  const SetupMenu({super.key});

  @override
  State<SetupMenu> createState() => _SetupMenuState();
}


class _SetupMenuState extends State<SetupMenu> {
    // Controllers
  final player1nameController = TextEditingController();
  final player2nameController = TextEditingController();
  final player1ratingController = TextEditingController();
  final player2ratingController = TextEditingController();
  final startScoreController = TextEditingController();
  final legCountController = TextEditingController();


    // Button press tracking variables
  String player1Type = '';
  String player2Type = '';

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
                buildButtonPair(
                    label1: 'Player',
                    label2: 'Bot',
                    selected1: player1Type,
                    selected2: player2Type,
                    onSelected1: (val) {
                      setState(() {
                        player1Type = val;
                      });
                    },
                    onSelected2: (val) {
                      setState(() {
                        player2Type = val;
                      });
                    },
                  ),
            SizedBox(height: 24),
              Row(
                children: [
                  buildTextWithTextField('Start Score (501/301)', startScoreController),
                  buildTextWithTextField('Leg Count', legCountController),
                ],
              ),
              

              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                    MatchEngine matchEngine = createMatch();
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => MatchMenu(matchEngine: matchEngine),
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
    required Function(String) onSelected2,
    required String selected1,
    required String selected2,
  }) {
    return Row(children: [
        Expanded(
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
                child: Text(label2),
              ),
            ),
          ],
        ),
      ),
    ),

    Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => onSelected2(label1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selected2 == label1 ? Colors.green : Colors.white,
                ),
                child: Text(label1, style: TextStyle(fontSize: 11)),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => onSelected2(label2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: selected2 == label2 ? Colors.green : Colors.white,
                ),
                child: Text(label2),
              ),
            ),
          ],
        ),
      ),
    )
    ],);
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
    
    
    MatchLogic rules = MatchLogic(int.parse(startScoreController.text), 
               int.parse(legCountController.text), 
               false, 0, false, false);

    return MatchEngine(player1, player2, rules, context);

  }
}