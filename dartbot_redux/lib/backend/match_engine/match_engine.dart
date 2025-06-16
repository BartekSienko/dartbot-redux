import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';
import 'package:flutter/foundation.dart';  // for ChangeNotifier

import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:flutter/material.dart';

class MatchEngine extends ChangeNotifier{
  DartPlayer player1;
  DartPlayer player2;
  final MatchLogic matchRules;
  int throwing = 1;
  int onThrow = 1;
  int onThrowSet = 1;


  MatchEngine(this.player1, this.player2, this.matchRules);

  void initMatch() {
    newLeg();
    onThrow = 1;
    onThrowSet = 1;
    throwing = 1;
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
      checkForMatchWinner(player1);
      newLeg();
    } else if (player2.score <= 0) {
      player2.legs++;
      player1.score = 0;
      checkForMatchWinner(player2);
      newLeg();
    }

    if (matchRules.isSetPlay) {
      checkForFinishedSet();
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
        /// MATCH IS OVER!!!
      }
    } else {
      if (player.legs >= matchRules.legLimit) {
       /// MATCH IS OVER!!
      }
    }
  }

}