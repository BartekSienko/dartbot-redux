// ignore_for_file: use_build_context_synchronously

import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';

import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/duo_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/backend/match_engine/player_match_stats.dart';
import 'package:dartbot_redux/backend/match_engine/sim_match_engine.dart';
import 'package:flutter/material.dart';

class MatchEngine extends ChangeNotifier{
  BuildContext? context;
  DartPlayer player1;
  DartPlayer player2;
  final MatchLogic matchRules;
  int throwing = 1;
  int onThrow = 1;
  int onThrowSet = 1;
  bool matchFinished;
  int winner;


  MatchEngine(this.player1, this.player2, this.matchRules, [this.context]): matchFinished = false, winner = 0;



  Future<void> initMatch() async {
    newLeg();
    onThrow = 1;
    onThrowSet = 1;
    throwing = 1;
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (player1 is DartBot) {
      DartBot p1 = player1 as DartBot;
      await p1.visualVisitThrow(matchRules.doubleOut, 
                            matchRules.doubleIn, context!, onComplete: () {
      checkForFinishedLeg();
      notifyListeners();
      throwing = 2;
      checkForDartBot(context!);
      });
    }
    });
  }



  void simPortion(int count, String simming) {
    DartBot p1Copy = player1.createBotCopy();
    DartBot p2Copy = player2.createBotCopy();
    SimMatchEngine simEngine;
    
    
    if (simming == 'leg') {
      MatchLogic copyRules = MatchLogic(matchRules.startScore, 1, 
                                        false, 0, 
                                        matchRules.doubleOut, matchRules.doubleIn, 
                                        false);
      
      simEngine = SimMatchEngine(p1Copy, p2Copy, copyRules, false);
    } else if (simming == 'set') {
      MatchLogic copyRules = MatchLogic(matchRules.startScore, matchRules.legLimit, 
                                        matchRules.isSetPlay, 1, 
                                        matchRules.doubleOut, matchRules.doubleIn, 
                                        false);
      simEngine = SimMatchEngine(p1Copy, p2Copy, copyRules, false);

    } else {
      p1Copy.sets = player1.sets;
      p2Copy.sets = player2.sets;

      simEngine = SimMatchEngine(p1Copy, p2Copy, matchRules, false);
    }

    int won = simEngine.simMatch();

    player1.combine(p1Copy);
    player2.combine(p2Copy);

    DartPlayer p = won == 1 ? player1 : player2;

    checkForMatchWinner(p, won, false);
  }




  void newLeg() {
        player1.score = matchRules.getStartScore();
        player1.stats.dartsThrownLeg = 0;
        player2.score = matchRules.getStartScore();
        player2.stats.dartsThrownLeg = 0;
        if (onThrow == 1) {
            setThrow(2, false);
        } else {
            setThrow(1, false);
        }
        if (player1.legs == 0 && player2.legs == 0) {
            if (onThrowSet == 1) {
              setThrow(2, true);
            } else {
              setThrow(1, true);
            }
        }
        throwing = onThrow;
    }

  void setThrow(int nr, bool ifSetPlay) {
      if (ifSetPlay) {
        onThrowSet = nr; 
      }
      onThrow = nr;
  }




  Future<bool> visitThrow(int pointsScored, BuildContext context) async {
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
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Center(child: Text("Illegal Score inputed!\nIf it's a bust, input '0'")),
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
      return false;
    }
    
    Set<int> possibleDartsAtDouble = playerThrowing.getPossibleDartsAtDouble(pointsScored);
    Set<int> possibleDartsAtCheckout = playerThrowing.getPossibleDartsForCheckout(pointsScored);

    List<int> dartsAtFinishing = await getDartsAtFinishing(possibleDartsAtDouble, possibleDartsAtCheckout, context); 

    int dartsAtDouble = dartsAtFinishing[0];
    int dartsAtCheckout = dartsAtFinishing[1];
  
    playerThrowing.stats.doublesAttempted += dartsAtDouble;
    playerThrowing.score -= pointsScored;
    playerThrowing.dartThrow(pointsScored, matchRules.doubleOut, dartsAtCheckout);

    // Hands the "turn" to the next player
    if (throwing == 1) {
      throwing = 2;
    } else {
      throwing = 1;
    }
    
    
    checkForFinishedLeg();
    
    notifyListeners();

    await checkForDartBot(context);


    return true;
  }


  Future<void> checkForDartBot(BuildContext context) async {
    if (throwing == 1 && player1 is DartBot) {
      DartBot p1 = player1 as DartBot;
      await p1.visualVisitThrow(matchRules.doubleOut, 
                            matchRules.doubleIn, context, onComplete: () async {
      throwing = 2;
      checkForFinishedLeg();
      notifyListeners();
      await checkForDartBot(context);

      });
    } else if (throwing == 2 && player2 is DartBot) {
      DartBot p2 = player2 as DartBot;
      await p2.visualVisitThrow(matchRules.doubleOut, 
                            matchRules.doubleIn, context, onComplete: () async {
      throwing = 1;
      checkForFinishedLeg();
      notifyListeners();
      await checkForDartBot(context);

      });
    } else {
      return;
    }
  }

  
  void checkForFinishedLeg() {
    if (player1.score <= 0) {
      player1.legs++;
      player2.score = 0;
      checkForNewBestWorst(player1);
      checkForMatchWinner(player1, 1, false);
      newLeg();
    } else if (player2.score <= 0) {
      player2.legs++;
      player1.score = 0;
      checkForNewBestWorst(player2);
      checkForMatchWinner(player2, 2, false);
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
            checkForMatchWinner(player1, 1, false);
            newLeg();
        } else if (player2.legs >= matchRules.getLegLimit()) {
            player2.sets++;
            player1.legs = 0;
            player2.legs = 0;
            checkForMatchWinner(player2, 2, false);
            newLeg();
        }
  }

  void checkForMatchWinner(DartPlayer player, int nr, bool ifDoublePop) {
    DartPlayer maybeWon;
    DartPlayer maybeLost;
    
    if (player1 == player) {
      maybeWon = player1;
      maybeLost = player2;
    } else {
      maybeWon = player2;
      maybeLost = player1;
    }

    bool leadingBy2 = !matchRules.winBy2 || (maybeWon.legs - maybeLost.legs > 1);
    bool isSuddenDeath = player.legs >= (matchRules.legLimit + 3);


    if (matchRules.isSetPlay) {
      if (player.sets >= matchRules.setLimit && (leadingBy2 || isSuddenDeath)) {
        winner = nr;
        matchFinished = true;
        showMatchStats(context, ifDoublePop);
      }
    } else {
      if (player.legs >= matchRules.legLimit && (leadingBy2 || isSuddenDeath)) {
       winner = nr;
       matchFinished = true;
       showMatchStats(context, ifDoublePop);
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


  void showMatchStats(BuildContext? context, bool ifDoublePop) {
    if (context == null) return;

    // Save the outer context
    final outerContext = context;

  showDialog(
    context: outerContext,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Center(child: Text('Match Stats')),
        content: generateMatchStats(),
        actions: [
          TextButton(
            child: Text('Close'),
            
            onPressed: () {
              Navigator.of(dialogContext).pop(); // close the dialog
              if (matchFinished) {
                Navigator.of(outerContext).pop(winner);
                if (ifDoublePop) Navigator.of(outerContext).pop(winner);
                

              }
                     
            },
          ),
        ],
      );
    },
  );

  
}

  Future<List<int>> getDartsAtFinishing(Set<int> possibleDoubles, 
                                        Set<int> possibleCheckouts, 
                                        BuildContext context) async {
    
    int dartsAtDouble = possibleDoubles.first;
    int dartsAtCheckout = possibleCheckouts.first;
    
    bool checkForDoubles = possibleDoubles.length > 1;
    bool checkForCheckouts = possibleCheckouts.length > 1;
    
    if (!checkForDoubles && !checkForCheckouts) {
      return [dartsAtDouble, dartsAtCheckout];
    }
  
  return await showDialog<List<int>>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: Column(
                children: [
                  if (checkForDoubles) Text("How many darts at double?"),
                  if (checkForDoubles)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: possibleDoubles.map((option) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              dartsAtDouble = option;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                dartsAtDouble == option ? Colors.black : Colors.grey,
                          ),
                          child: Text(option.toString(), style: TextStyle(color: Colors.white),),
                        );
                      }).toList(),
                    ),
                
                  if (checkForCheckouts) Text("How many darts at checkout?"),
                  if (checkForCheckouts)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: possibleCheckouts.map((option) {
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              dartsAtCheckout = option;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                dartsAtCheckout == option ? Colors.black : Colors.grey,
                          ),
                          child: Text(option.toString(), style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    )         
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Close', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.of(dialogContext).pop([dartsAtDouble, dartsAtCheckout]);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  ) ?? [dartsAtDouble, dartsAtCheckout];  
  }


}