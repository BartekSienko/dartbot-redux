import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';

import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/backend/match_engine/player_match_stats.dart';
import 'package:flutter/material.dart';

class MatchEngine extends ChangeNotifier{
  BuildContext context;
  DartPlayer player1;
  DartPlayer player2;
  final MatchLogic matchRules;
  int throwing = 1;
  int onThrow = 1;
  int onThrowSet = 1;


  MatchEngine(this.player1, this.player2, this.matchRules, this.context);

  void initMatch() {
    newLeg();
    onThrow = 1;
    onThrowSet = 1;
    throwing = 1;
    if (player1 is DartBot) {
      DartBot p1 = player1 as DartBot;
      p1.visitThrow(0, matchRules.doubleOut, 
                            matchRules.doubleIn, "");
      notifyListeners();
      throwing = 2;
    }
  }

  void newLeg() {
        player1.score = matchRules.getStartScore();
        player1.stats.dartsThrownLeg = 0;
        player2.score = matchRules.getStartScore();
        player2.stats.dartsThrownLeg = 0;
        if (onThrow == 1) {
            onThrow = 2;
        } else {
            onThrow = 1;
        }
        if (player1.legs == 0 && player2.legs == 0) {
            if (onThrowSet == 1) {
                onThrow = 2;
                onThrowSet = 2;
            } else {
                onThrow = 1;
                onThrowSet = 1;
            }
        }
        throwing = onThrow;
    }



  bool visitThrow(int pointsScored) {
    DartPlayer playerThrowing;
    if (throwing == 1) {
      playerThrowing = player1;
    } else {
      playerThrowing = player2;
    }

    String errorString = "";
    bool successfulThrow = playerThrowing.visitThrow(pointsScored, 
                                                     matchRules.doubleOut, 
                                                     matchRules.doubleIn, 
                                                     errorString);
    
    if (!successfulThrow) {
      /// Is going to be replaced with a pop-up
      print("ERROR: $errorString");
      return false;
    }
    
    /// TODO: ADD POP-UP FOR DOUBLES AND DARTS AT CHECKOUT
    
    
    playerThrowing.score -= pointsScored;
    playerThrowing.dartThrow(pointsScored, matchRules.doubleOut, 3);

    // Hands the "turn" to the next player
    if (throwing == 1) {
      throwing = 2;
    } else {
      throwing = 1;
    }
  
    
    checkForFinishedLeg();
    
    notifyListeners();

    checkForDartBot();


    return true;
  }


  void checkForDartBot() {
    if (throwing == 1 && player1 is DartBot) {
      DartBot p1 = player1 as DartBot;
      p1.visitThrow(0, matchRules.doubleOut, 
                            matchRules.doubleIn, "");
    } else if (throwing == 1) {
      return;
    } else if (throwing == 2 && player2 is DartBot) {
      DartBot p2 = player2 as DartBot;
      p2.visitThrow(0, matchRules.doubleOut, 
                            matchRules.doubleIn, "");
    } else if (throwing == 2) {
      return;
    }

    if (throwing == 1) {
      throwing = 2;
    } else {
      throwing = 1;
    }
  
    
    checkForFinishedLeg();
    
    notifyListeners();

    checkForDartBot();
  }

  
  void checkForFinishedLeg() {
    if (player1.score <= 0) {
      player1.legs++;
      player2.score = 0;
      checkForNewBestWorst(player1);
      checkForMatchWinner(player1);
      newLeg();
    } else if (player2.score <= 0) {
      player2.legs++;
      player1.score = 0;
      checkForNewBestWorst(player2);
      checkForMatchWinner(player2);
      newLeg();
    }

    if (matchRules.isSetPlay) {
      checkForFinishedSet();
    }

  }

  void checkForNewBestWorst(DartPlayer player) {
    int dartsThrown = player.stats.dartsThrownLeg;
    if (player.stats.bestLeg == 0) {
      player.stats.bestLeg = dartsThrown;
      player.stats.worstLeg = dartsThrown;
    } else if (player.stats.bestLeg > dartsThrown) {
      player.stats.bestLeg = dartsThrown;
    } else if (player.stats.worstLeg < dartsThrown) {
      player.stats.worstLeg = dartsThrown;
    }
  }

  void checkForFinishedSet() {
    if (player1.legs >= matchRules.getLegLimit()) {
            player1.sets++;
            player1.legs = 0;
            player2.legs = 0;
            checkForMatchWinner(player1);
            newLeg();
        } else if (player2.legs >= matchRules.getLegLimit()) {
            player2.sets++;
            player1.legs = 0;
            player2.legs = 0;
            checkForMatchWinner(player2);
            newLeg();
        }
  }

  void checkForMatchWinner(DartPlayer player) {
    if (matchRules.isSetPlay) {
      if (player.sets >= matchRules.setLimit) {
        showMatchStats(context);
      }
    } else {
      if (player.legs >= matchRules.legLimit) {
       showMatchStats(context);
      }
    }
  }

  Widget generateMatchStats() {
    PlayerMatchStats p1Stats = player1.stats;
    PlayerMatchStats p2Stats = player2.stats;
    return Table(
      children: [
        generateStatRow(player1.name, "Stats", player2.name),
        generateStatRow(p1Stats.getListAverage(p1Stats.scores).toString(), "3DA", p2Stats.getListAverage(p2Stats.scores).toString()),
        generateStatRow(p1Stats.getListAverage(p1Stats.first9scores).toString(), "First 9", p2Stats.getListAverage(p2Stats.first9scores).toString()),
        generateStatRow(p1Stats.getCheckoutSplit(), "Checkouts", p2Stats.getCheckoutSplit()),
        generateStatRow(p1Stats.getHighestFromList(p1Stats.scores).toString(), "High Score", p2Stats.getHighestFromList(p2Stats.scores).toString()),
        generateStatRow(p1Stats.getHighestFromList(p1Stats.checkouts).toString(), "High. Out", p2Stats.getHighestFromList(p2Stats.checkouts).toString()),
        generateStatRow(p1Stats.bestLeg.toString(), "Best Leg", p2Stats.bestLeg.toString()),
        generateStatRow(p1Stats.worstLeg.toString(), "Worst Leg", p2Stats.worstLeg.toString()),
      
        ]);
  }

  TableRow generateStatRow(String text1, String text2, String text3) {
    return TableRow(children: [
          Align(alignment: Alignment.centerRight, child: Text(text1, style: TextStyle(fontSize: 12),)),
          Align(alignment: Alignment.center,      child: Text(text2, style: TextStyle(fontSize: 12))),
          Align(alignment: Alignment.centerLeft,  child: Text(text3, style: TextStyle(fontSize: 12))),

    ]
    );

  }


  void showMatchStats(BuildContext context) {

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
              Navigator.of(context).pop();       // pop the page
            },
          ),
        ],
      );
    },
  );

  
}

}