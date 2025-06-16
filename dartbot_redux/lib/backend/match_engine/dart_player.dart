// ignore_for_file: unnecessary_this, avoid_print, file_names

import 'dart:collection';
import 'dart:io';

import 'package:dartbot_redux/backend/match_engine/player_match_stats.dart';

class DartPlayer {
  String name;
  int score = 0;
  int legs = 0;
  int sets = 0;
  PlayerMatchStats stats = PlayerMatchStats();
  double rating;
  //OverallPrizeMoney prizeMoney;

  DartPlayer(this.name, this.rating) {
    //prizeMoney = OverallPrizeMoney();
  }

  void dartThrow(int pointsScored, bool isDoubleOut, int dartsAtCheckout) {
    if (score == 0) {
      stats.addCheckout(pointsScored, dartsAtCheckout);
    } else {
      stats.addScore(pointsScored, 3);
    }
  }

  /// TODO: Rewrite function when connecting to frontend (Visits)
  void visitThrow(bool isDoubleOut, bool isDoubleIn) {
    int pointsScored = 0;
    bool legalScore = false;
    print('$name to throw: ');
    while (!legalScore) {
      int? input = int.tryParse(stdin.readLineSync()!);
      if (input is int) {
        pointsScored = input;
        legalScore = true;
      } else {
        legalScore = false;
        continue;
      }
      legalScore = legalScore && checkLegalScore(pointsScored, isDoubleOut);
      if (score == pointsScored) {
        legalScore = legalScore && checkLegalDoubleScore(pointsScored, true);
      } else if (stats.dartsThrownLeg == 0 && isDoubleIn) {
        legalScore = legalScore && checkLegalDoubleScore(pointsScored, false);
      }
    }

    int dartsAtDouble = visitDoubles(pointsScored);
    stats.doublesAttempted += dartsAtDouble;
    int dartsAtCheckout = visitCheckout(pointsScored, dartsAtDouble);

    score -= pointsScored;
    dartThrow(pointsScored, isDoubleOut, dartsAtCheckout);
  }

  /// TODO: Rewrite function when connecting to frontend (Doubles)
  int visitDoubles(int pointsScored) {
    Set<int> possibleDartsAtDouble = getPossibleDartsAtDouble(pointsScored);
    Set<int> impossibleCheckouts = HashSet.from([169, 168, 166, 165, 163, 162, 159]);
    if ((score - pointsScored) >= 50 || (impossibleCheckouts.contains(score) || score > 170)) {
      return 0;
    } else if (score - pointsScored == 0) {
      possibleDartsAtDouble.remove(0);
    }
    int dartsAtDouble = 99;
    if (possibleDartsAtDouble.length == 1) {
      dartsAtDouble = possibleDartsAtDouble.first;
    } else {
      print('How many darts at double? ${possibleDartsAtDouble.toString()}');
      while (!possibleDartsAtDouble.contains(dartsAtDouble)) {
        int? input = int.tryParse(stdin.readLineSync()!);
        if (input is int) {
          dartsAtDouble = input;
        }
      }
    }
    return dartsAtDouble;
  }

  /// TODO: Rewrite function when connecting to frontend (Checkouts)
  int visitCheckout(int pointsScored, int dartsAtDouble) {
    if (score != pointsScored) {
      return 0;
    }
    Set<int> possibleDartsAtCheckout = getPossibleDartsForCheckout(pointsScored, dartsAtDouble);
    if (possibleDartsAtCheckout.length == 1) {
      return 3;
    } else {
      int dartsAtCheckout = 99;
      print('How many darts at checkout? ${possibleDartsAtCheckout.toString()}');
      while (!possibleDartsAtCheckout.contains(dartsAtCheckout)) {
        int? input = int.tryParse(stdin.readLineSync()!);
        if (input is int) {
          dartsAtCheckout = input;
        }
      }
      return dartsAtCheckout;
    }
  }

  bool checkLegalScore(int pointsScored, bool isDoubleOut) {
    Set<int> impossibleScores = HashSet<int>.from([179, 178, 176, 175, 173, 172, 169, 166, 163]);
    if (impossibleScores.contains(pointsScored) || pointsScored > 180) {
      print("Impossible score inputed");
      return false;
    } else if (pointsScored > score) {
      print("BUST! Too large score inputed (please input 0)");
      return false;
    } else if (isDoubleOut && (score - pointsScored == 1)) {
      print("BUST! You cannot checkout 1 (please input 0)");
      return false;
    }
    return true;
  }

  bool checkLegalDoubleScore(int pointsScored, bool outNotIn) {
    Set<int> impossibleCheckouts = HashSet<int>.from([169, 168, 166, 165, 163, 162, 159]);
    if (impossibleCheckouts.contains(pointsScored) || pointsScored > 170) {
      if (outNotIn) {
        print("Impossible checkout inputed");
      } else {
        print("Impossible start score inputed");
      }
      return false;
    }
    return true;
  }

  Set<int> getPossibleDartsForCheckout(int checkoutScore, int dartsAtDouble) {
    Set<int> onlyThreeDartOuts = HashSet<int>.from([109, 108, 106, 105, 104, 103, 102, 101, 99]);
    if (checkoutScore > 110 || onlyThreeDartOuts.contains(checkoutScore)) {
      return HashSet<int>.from([3]);
    } else if (checkoutScore != 50 && (checkoutScore > 40 || checkoutScore % 2 == 1)) {
      Set<int> result = HashSet<int>.from([2, 3]);
      // On a 2-dart finish, if 2 shots are needed on the double, the checkout has to take 3 darts
      if (dartsAtDouble == 2) {
        result.remove(2);
      }
      return result;
    } else {
      switch (dartsAtDouble) {
        case 3:
          return HashSet<int>.from([3]);
        case 2:
          return HashSet<int>.from([2, 3]);
        case 1:
          return HashSet<int>.from([1]);
        default:
          throw ArgumentError("dartsAtDouble wasn't 1, 2 or 3");
      }
    }
  }

  Set<int> getPossibleDartsAtDouble(int pointsScored) {
    Set<int> onlyThreeDartOuts = HashSet<int>.from([109, 108, 106, 105, 104, 103, 102, 101, 99]);
    if (pointsScored > 110 || onlyThreeDartOuts.contains(pointsScored)) {
      return HashSet<int>.from([0, 1]);
    } else if (pointsScored != 50 && (pointsScored > 40 || pointsScored % 2 == 1)) {
      return HashSet<int>.from([0, 1, 2]);
    } else {
      return HashSet<int>.from([0, 1, 2, 3]);
    }
  }

  void updateBestWorstLegs() {
    int dartsThrownLeg = stats.dartsThrownLeg;
    PlayerMatchStats legStats = stats;
    if (legStats.bestLeg == 0 && legStats.worstLeg == 0) {
      legStats.bestLeg = dartsThrownLeg;
      legStats.worstLeg = dartsThrownLeg;
    } else if (legStats.bestLeg > dartsThrownLeg) {
      legStats.bestLeg = dartsThrownLeg;
    } else if (legStats.worstLeg < dartsThrownLeg) {
      legStats.worstLeg = dartsThrownLeg;
    }
  }

  @override
  String toString() {
    return "($legs)  $score  $name";
  }

  String toStringSetPlay() {
        return "(${this.sets}) (${this.legs})  ${this.score}  ${this.name}";
    }

  String toStringStats() {
  return this.name + this.stats.toString();
}

@override
int get hashCode {
  return this.name.hashCode;
}

@override
bool operator ==(Object other) {
  if (other is DartPlayer) {
    return equals(other);
  }
  return false;
}

bool equals(DartPlayer other) {
  bool nameCheck = this.name == other.name;
  bool scoreCheck = this.score == other.score;
  bool legCheck = this.legs == other.legs;
  bool setCheck = this.sets == other.sets;
  bool statCheck = this.stats == other.stats;
  return nameCheck && scoreCheck && legCheck && setCheck && statCheck;
}

}


