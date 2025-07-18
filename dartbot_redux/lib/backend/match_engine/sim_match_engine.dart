




import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:flutter/material.dart';

class SimMatchEngine extends MatchEngine{
  bool fullSim;

  SimMatchEngine(super.player1, super.player2, super.matchRules, this.fullSim, [super.context]);


  int simMatch() {

    newLeg();
    onThrow = 1;
    onThrowSet = 1;
    throwing = 1;

      while (!matchFinished) {
          if (throwing == 1 && player1 is DartBot) {
          DartBot p1 = player1 as DartBot;
          p1.visitThrow(0, matchRules.doubleOut, 
                                matchRules.doubleIn, "");
          } else if (throwing == 2 && player2 is DartBot) {
            DartBot p2 = player2 as DartBot;
            p2.visitThrow(0, matchRules.doubleOut, 
                                  matchRules.doubleIn, "");
          }

          if (throwing == 1) {
            throwing = 2;
          } else {
            throwing = 1;
          }
    
          checkForFinishedLeg();
          

      }
      
      return winner;
  }

  @override
  void showMatchStats(BuildContext? context, bool ifDoublePop) {
    if (context == null) return;

    if (!fullSim) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Center(child: Text('Match Stats')),
            content: generateMatchStats(),
            actions: [
              TextButton(
                child: Text('Close'),
                
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  

  
}



}