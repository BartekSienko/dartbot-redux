

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
  int remainingPlayerCount; //?
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
      remainingPlayerCount = playerCount,
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

    if (result != 0) {
      match.winner = result;
      match.player1 = p1Playing;
      match.player2 = p2Playing;
      match.ifPlayed = true;
    }
    


    if (allMatchesFinished()) {
      curRoundNr++;
      rounds.add(generateRound());
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


  String getRoundName() {
    List<TourMatch> curRound = rounds[curRoundNr];

    if (remainingPlayerCount == 2 && curRound.length == 1) {
      return "Final";
    } else if (remainingPlayerCount == 4 && curRound.length == 2) {
      return "Semi-Final";
    } else if (remainingPlayerCount == 8 && curRound.length == 4) {
      return "Quarter-Final";
    } else {
      return "Round ${curRoundNr + 1}";
    }
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