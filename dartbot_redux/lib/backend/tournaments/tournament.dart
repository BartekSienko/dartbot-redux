

import 'dart:math';

import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';
import 'package:dartbot_redux/backend/match_engine/match_engine.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/backend/match_engine/sim_match_engine.dart';
import 'package:dartbot_redux/backend/tournaments/tour_match.dart';
import 'package:dartbot_redux/frontend/match_menu/match_menu.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:flutter/material.dart';

class Tournament {
  String name;
  String tag;
  MatchTheme matchTheme;
  int playerCount;
  List<List<DartPlayer>> players; // List with index for starting round
  List<List<TourMatch>> rounds;
  List<List<DartPlayer>> eliminated; // List with index for eliminated round
  List<MatchLogic> rulesets;
  List<int> prizeMoney;
  int curRoundNr;
  String lastWinner;


  Tournament(this.name, this.tag, this.matchTheme, this.playerCount, this.players, this.rulesets, this.prizeMoney, this.lastWinner)
    : rounds = [],
      eliminated = [],
      curRoundNr = 0;


  List<TourMatch> generateRound() {
    List<DartPlayer> playing = players[curRoundNr];
    List<TourMatch> round = [];
    int roundMatchCount = (playing.length / 2).round();
    for (int i = 0; i < roundMatchCount; i++) {
        round.add(TourMatch(playing[i], playing[playing.length - i - 1]));    }
    
    return round;
  }
  
  Future<void> playMatch(TourMatch match, String p1Status, String p2Status, BuildContext context) async {
    DartPlayer p1Playing;
    DartPlayer p2Playing;
    int result = 0;

    if (p1Status == 'bot') {
      p1Playing = DartBot(match.player1.name, match.player1.rating);
    } else {
      p1Playing = DartPlayer(match.player1.name, match.player1.rating);
    }
    if (p2Status == 'bot') {
      p2Playing = DartBot(match.player2.name, match.player2.rating);
    } else {
      p2Playing = DartPlayer(match.player2.name, match.player2.rating);
    }

    MatchLogic matchRules = rulesets[curRoundNr];

    if (p1Playing is DartBot && p2Playing is DartBot) {
      SimMatchEngine matchEngine = SimMatchEngine(p1Playing, p2Playing, matchRules, false, context);
      result = matchEngine.simMatch();
      
      
    } else {
      MatchEngine matchEngine = MatchEngine(p1Playing, p2Playing, matchRules, context);
      result = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                      builder: (context) => MatchMenu(matchTitle: name, 
                                                      matchTheme: matchTheme, 
                                                      matchEngine: matchEngine),
                      ),
                      ) ?? 0;
    }

    match.player1 = p1Playing;
    match.player2 = p2Playing;

    if (result != 0) {
      match.winner = result;
      match.ifPlayed = true;
      movePlayersToNextRound(match);
    }
    


  }

  bool allMatchesFinished() {
    List<TourMatch> currentRound = rounds[curRoundNr];
    for (int i = 0; i < currentRound.length; i++) {
      if (!currentRound[i].ifPlayed) {
          return false;
      }
    }
    return true;
  }


  void simRound(BuildContext context) {
    List<TourMatch> currentRound = rounds[curRoundNr];
    MatchLogic matchRules = rulesets[curRoundNr];

    for (int matchNr = 0; matchNr < currentRound.length; matchNr++) {
      TourMatch currentMatch = currentRound[matchNr];
      if (currentMatch.ifPlayed) continue;

      DartPlayer p1Playing = DartBot(currentMatch.player1.name, currentMatch.player1.rating);
      DartPlayer p2Playing = DartBot(currentMatch.player2.name, currentMatch.player2.rating);


      SimMatchEngine matchEngine = SimMatchEngine(p1Playing, p2Playing, matchRules, true, context);
      int result = matchEngine.simMatch();
      
      currentMatch.player1 = p1Playing;
      currentMatch.player2 = p2Playing;
      currentMatch.winner = result;
      currentMatch.ifPlayed = true;
      movePlayersToNextRound(currentMatch);
    }
  }


  void movePlayersToNextRound(TourMatch match) {
    DartPlayer player1 = findPlayerInList(match.player1);
    DartPlayer player2 = findPlayerInList(match.player2);

    if (players.length == (curRoundNr + 1)) {
      players.add([]);
    }
    if (eliminated.length == (curRoundNr)) {
      eliminated.add([]);
    }

    if (match.winner == 1) {
      adjustPlayerRatings(player1, player2);
      players[curRoundNr + 1].add(player1);
      eliminated[curRoundNr].add(player2);
      
    } else {
      adjustPlayerRatings(player2, player1);
      players[curRoundNr + 1].add(player2);
      eliminated[curRoundNr].add(player1);
    }
  }

  DartPlayer findPlayerInList(DartPlayer copiedPlayer) {
    List<DartPlayer> playing = players[curRoundNr];

    for (int i = 0; i < playing.length; i++) {
      if (copiedPlayer.name == playing[i].name) {
        return playing[i];
      }
    }


    throw Exception();
  }
  
  void adjustPlayerRatings(DartPlayer winner, DartPlayer loser) {
    double ratingDiff = winner.rating - loser.rating;
    double winnerUpgrade = 0.0001 * pow(ratingDiff, 3) 
                           + 0.002 * pow(ratingDiff,2)
                           + 0.02 * ratingDiff + 0.09;
    print("Before Ratings:\n${winner.rating} vs ${loser.rating}");
    //Will be positive
    if (winnerUpgrade < 0) winnerUpgrade = 0;

    //Will be negative
    double loserDowngrade = 0.00004 * pow(ratingDiff,3)
                            - 0.0026 * pow(ratingDiff,2)
                            + 0.037 * ratingDiff - 0.16;

    if (loserDowngrade > 0) loserDowngrade = 0;

    winner.rating += winnerUpgrade / 2;
    loser.rating += loserDowngrade;
    print("After Ratings:\n${winner.rating} vs ${loser.rating}");
  }

  String getRoundName() {
    List<TourMatch> curRound = rounds[curRoundNr];
    List<DartPlayer> curRoundPlayers = players[curRoundNr];

    int matchCount = curRound.length;
    int playerCount = curRoundPlayers.length;
    

    if (playerCount == 2 && matchCount == 1 &&
        rulesets.length == (curRoundNr + 1)) {
      return "Final";
    } else if (playerCount == 4 && matchCount == 2 &&
        rulesets.length == (curRoundNr + 2)) {
      return "Semi-Final";
    } else if (playerCount == 8 && matchCount == 4 &&
        rulesets.length == (curRoundNr + 3)) {
      return "Quarter-Final";
    } else {
      return "Round ${curRoundNr + 1}";
    }
  }

  bool isFinished() {
    return (players[curRoundNr].length == 1 &&
            rulesets.length == curRoundNr);
    }

}


void main() {

  List<DartPlayer> round0 = [DartPlayer("Shinsuke", 12),
                             DartPlayer("Kinako", 12),
                             DartPlayer("Hugo", 13),
                             DartPlayer("Fei", 13),
                             DartPlayer("Gwen", 15),
                             DartPlayer("Kiname", 14),
                             DartPlayer("Barenko", 15),
                             DartPlayer("Clara", 14)];
  List<DartPlayer> round1 = [DartPlayer("Shinsuke", 12),
                             DartPlayer("Kinako", 12),
                             DartPlayer("Hugo", 13),
                             DartPlayer("Fei", 13)];
  List<DartPlayer> round2 = [DartPlayer("Gwen", 15),
                             DartPlayer("Kiname", 14)]; 
  List<DartPlayer> round3 = [DartPlayer("Barenko", 15),
                             DartPlayer("Clara", 14)]; 

  List<List<DartPlayer>> players = [round0, round1, round2, round3];


  MatchLogic rules1 = MatchLogic(301, 6, false, 0, true, false);
  MatchLogic rules2 = MatchLogic(301, 8, false, 0, true, false);
  List<MatchLogic> rulesets = [rules1, rules1, rules1, rules2];

  List<int> prizeMoney = [120, 60, 40, 25, 12, 8];


  Tournament t = Tournament("Test Cup", "PC1", MatchTheme("def"), 6, players, rulesets, prizeMoney, "None");

  // ignore: avoid_print
  print(t.generateRound());
  }