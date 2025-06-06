

// ignore_for_file: avoid_print

import 'dart:collection';
import 'dart:io';

import 'package:dartbot_redux/backend/match_engine/DartPlayer.dart';
import 'package:dartbot_redux/backend/match_engine/MatchDriver.dart';
import 'package:dartbot_redux/backend/match_engine/MatchLogic.dart';
import 'package:dartbot_redux/backend/match_engine/dartbot/DartBot.dart';

class Tournament {
  final String name;
  int playerCount;
  final List<Queue<DartPlayer>> players;
  final Queue<DartPlayer> eliminated;
  final List<MatchLogic> rulesets;
  final List<int> prizeMoney;
  int roundMatchNumber;

  Tournament(this.name, this.playerCount, this.players, 
             this.rulesets, this.prizeMoney) :
    eliminated = Queue(),
    roundMatchNumber = 0;

  void simTournament() {
    Queue<DartPlayer> round1 = players.first;
    Queue<DartPlayer> round2;
    try {
      round2 = players[1];
    } on RangeError {
      round2 = Queue();
    }

    startRound(1, round1, round2);

    //generatePrizeMoney();
    if (eliminated.isNotEmpty) {
      print("The winner of $name is $eliminated[0].name!");
    }
  }

  void startRound(int roundNr, Queue<DartPlayer> competingPlayers, 
                  Queue<DartPlayer> nextRound) {
    String roundName;
    if (playerCount == 8) {
      roundName = "Quarter-Final";
    } else if (playerCount == 4) {
      roundName = "Semi-Final"; 
    } else if (playerCount == 2) {
      roundName = "Final";
    } else {
      roundName = roundNr.toString();
    }

    print("----------");
    print("Current Round: $roundName");

    int matchCount = competingPlayers.length / 2 as int;
    printMatchList(competingPlayers, matchCount);

    for (int i = roundMatchNumber; i < matchCount; i++) {
      roundMatchNumber++;
      DartPlayer p1 = competingPlayers.removeFirst();
      DartPlayer p2 = competingPlayers.removeLast();
      print("--------");
      printMatchInfo(p1.name, p2.name);

      DartPlayer p1Playing;
      DartPlayer p2Playing;

      int input = getIntInRange(0, 5);
      bool ifQuickSim = false;

      if (input == 0) {
        //SAVE TOURNAMENT!!!
        return;
      }
      if (input == 5) {
        ifQuickSim = true;
      }
      if (input == 1 || input == 3) {
        p1Playing = DartPlayer(p1.name, p1.rating);
      } else {
        p1Playing = DartBot(p1.name, p1.rating);
      }

      if (input == 2 || input == 3) {
        p2Playing = DartPlayer(p2.name, p2.rating);
      } else {
        p2Playing = DartBot(p2.name, p2.rating);
      }

      MatchDriver matchDriver = MatchDriver(p1Playing, p2Playing, rulesets[roundNr-1]);
      DartPlayer winner = matchDriver.runMatch(ifQuickSim);

      if (p1Playing.equals(winner)) {
        nextRound.add(p1);
        eliminated.addFirst(p2);
      } else {
        nextRound.add(p2);
        eliminated.addFirst(p1);
      }
      playerCount--;
    }

    if (nextRound.length == 1) {
      eliminated.addFirst(nextRound.first);
    } else {
      Queue<DartPlayer> followingRound;
      if (players.length > (roundNr + 1)) {
        followingRound = players[roundNr + 1];
      } else {
        followingRound = Queue();
      }
      roundMatchNumber = 0;
      startRound(roundNr, nextRound, followingRound);
    }

  }

  int getIntInRange(int minLimit, int maxLimit) {
    int input = -1;
    while (input < minLimit || input > maxLimit) {
        String? line = stdin.readLineSync();
      if (line != null && int.tryParse(line) != null) {
        input = int.parse(line);
      }
    }
    return input;
    }

  void printMatchInfo(String name1, String name2) {
    print("Match: $name1 vs $name2");
    print("Select option: ");
    print("0: Go Back");
    print("1: Play as $name1");
    print("2: Play as $name2");
    print("3: Play as both players");
    print("4: Sim Match (Bot vs Bot)");
    print("5: Quick Sim Match (Bot vs Bot)");
    }

  void printMatchList(Queue<DartPlayer> players, int matchCount) {
      Queue<DartPlayer> copy = Queue();
      for (DartPlayer p in players) {
          copy.add(p);
      }
      for (int i = 0; i < matchCount; i++) {
          print("Match $i.toString()+1: $copy.removeFirst().name vs $copy.removeLast().name");
      }
  }


}




