



import 'package:dartbot_redux/backend/match_engine/dart_player.dart';

class TourMatch {
  bool ifPlayed;
  DartPlayer player1;
  DartPlayer player2;
  int winner; // 1 if player 1, 2 if player 2

  TourMatch(this.player1, this.player2)
    : ifPlayed = false,
      winner = 0;

  factory TourMatch.fromString(String s) {
    bool parseBool(String v) => v.trim().toLowerCase() == "true";

    // Extract the inner player tuples: "(Name, rating)"
    final regex = RegExp(r'\([A-Za-z0-9\.\s]+,\s*[0-9\.]+\)');
    final matches = regex.allMatches(s).toList();

    // Expect: 2 matches = player1 and player2
    if (matches.length < 2) {
      throw FormatException("Could not extract two DartPlayer tuples in: $s");
    }

    DartPlayer p1 = DartPlayer.fromString(matches[0].group(0)!);
    DartPlayer p2 = DartPlayer.fromString(matches[1].group(0)!);

    // Remove outer parentheses to parse trailing fields
    String cleaned = s.replaceAll('(', '').replaceAll(')', '');
    List<String> parts = cleaned.split(',').map((v) => v.trim()).toList();

    // The last two parts are always: finished, winnerIndex
    bool finished = parseBool(parts[parts.length - 2]);
    int winnerIndex = int.parse(parts.last);

    TourMatch t = TourMatch(p1, p2);
    t.ifPlayed = finished;
    t.winner = winnerIndex;
    return t;
  }


  @override
  String toString() {
    return "(${player1.toString()} vs ${player2.toString()}, $ifPlayed, $winner)";
  }

}