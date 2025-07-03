

import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/backend/tournaments/tour_match.dart';

class Tournament {
  String name;
  String tag;
  int playerCount;
  int remainingPlayerCount; //?
  List<List<DartPlayer>> players; // List with index for starting round
  List<List<TourMatch>> rounds;
  List<List<DartPlayer>> eliminated; // List with index for eliminated round
  List<MatchLogic> rulesets;
  List<int> prizeMoney;
  int curRoundNr;
  String lastWinner;


  Tournament(this.name, this.tag, this.playerCount, this.players, this.rulesets, this.prizeMoney, this.lastWinner)
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


  Tournament t = Tournament("Test Cup", "PC1", 6, players, rulesets, prizeMoney, "None");

  // ignore: avoid_print
  print(t.generateRound());
  }