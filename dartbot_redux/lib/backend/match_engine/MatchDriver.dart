// ignore_for_file: avoid_print, file_names


import 'DartPlayer.dart';
import 'MatchLogic.dart';
import 'matchEngine.dart';
import 'dartbot/dartBot.dart';

class MatchDriver {
  final MatchEngine match;

  MatchDriver(DartPlayer player1, DartPlayer player2, MatchLogic rules)
      : match = MatchEngine(player1, player2, rules);

  DartPlayer runMatch(bool ifQuickSim) {
    DartPlayer? winner;
    int legCount = 0;
    bool matchFinished = false;

    print("Game on!");
    while (!matchFinished) {
      if (match.matchRules.isSetPlay && match.player1.legs == 0 && match.player2.legs == 0) {
        legCount = 0;
      }
      if (!ifQuickSim) print("Leg ${++legCount}:");
      match.playLeg(ifQuickSim);

      if (match.ifWinner(match.player1) != null) {
        print("${match.player1.name} has won the match!");
        matchFinished = true;
        winner = match.player1;
      } else if (match.ifWinner(match.player2) != null) {
        print("${match.player2.name} has won the match!");
        matchFinished = true;
        winner = match.player2;
      }
    }

    if (!ifQuickSim) {
      print("Match Stats:");
      print("");
      print(match.player1.toStringStats());
      print("");
      print(match.player2.toStringStats());
    }
    return winner!;
  }

}

void main() {
    print("Input Player 1 name: ");
    DartBot player1 = DartBot("Player 1", 100);
    print("Input Player 2 name: ");
    DartBot player2 = DartBot("Player 2", 1);
    print(player2.distroTables.toString());

    MatchDriver md = MatchDriver(player1, player2, MatchLogic(5001, 100, false, 0, true, false));
    md.runMatch(false);
  }