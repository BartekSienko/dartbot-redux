



import 'package:dartbot_redux/backend/match_engine/dart_player.dart';

class TourMatch {
  bool ifPlayed;
  DartPlayer player1;
  DartPlayer player2;
  int winner; // 1 if player 1, 2 if player 2

  TourMatch(this.player1, this.player2)
    : ifPlayed = false,
      winner = 0;


  @override
  String toString() {
    return "(${player1.toString()} vs ${player2.toString()}, $ifPlayed, $winner)";
  }

}