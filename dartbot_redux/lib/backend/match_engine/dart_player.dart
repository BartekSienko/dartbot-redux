// ignore_for_file: unnecessary_this, avoid_print, file_names

import 'dart:collection';
import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';
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

  bool visitThrow(int pointsScored, bool isDoubleOut, bool isDoubleIn, String errorString) {
    bool legalScore = true;
      legalScore = legalScore && checkLegalScore(pointsScored, isDoubleOut, errorString);
      if (score == pointsScored) {
        legalScore = legalScore && checkLegalDoubleScore(pointsScored, true, errorString);
      } 
      if (stats.dartsThrownLeg == 0 && isDoubleIn) {
        legalScore = legalScore && checkLegalDoubleScore(pointsScored, false, errorString);
      }
    return legalScore;
    }

  

  Set<int> getPossibleDartsAtDouble(int pointsScored) {
    Set<int> possibleDarts;
    Set<int> onlyThreeDartOuts = HashSet<int>.from([109, 108, 106, 105, 104, 103, 102, 101, 99]);
    if (pointsScored > 110 || onlyThreeDartOuts.contains(pointsScored)) {
      possibleDarts = HashSet<int>.from([0, 1]);
    } else if (pointsScored != 50 && (pointsScored > 40 || pointsScored % 2 == 1)) {
      possibleDarts = HashSet<int>.from([0, 1, 2]);
    } else {
      possibleDarts = HashSet<int>.from([0, 1, 2, 3]);
    }

    Set<int> impossibleCheckouts = HashSet.from([169, 168, 166, 165, 163, 162, 159]);
    if ((score - pointsScored) >= 50 || (impossibleCheckouts.contains(score) || score > 170)) {
      return HashSet<int>.from([0]);
    } else if (score - pointsScored == 0) {
      possibleDarts.remove(0);
    }

    return possibleDarts;
  }




  bool checkLegalScore(int pointsScored, bool isDoubleOut, String errorString) {
    Set<int> impossibleScores = HashSet<int>.from([179, 178, 176, 175, 173, 172, 169, 166, 163]);
    if (impossibleScores.contains(pointsScored) || pointsScored > 180) {
      errorString = ("Impossible score inputed");
      return false;
    } else if (pointsScored > score) {
      errorString = ("BUST! Too large score inputed (please input 0)");
      return false;
    } else if (isDoubleOut && (score - pointsScored == 1)) {
      errorString = ("BUST! You cannot checkout 1 (please input 0)");
      return false;
    }
    return true;
  }

  bool checkLegalDoubleScore(int pointsScored, bool outNotIn, String errorString) {
    Set<int> impossibleCheckouts = HashSet<int>.from([169, 168, 166, 165, 163, 162, 159]);
    if (impossibleCheckouts.contains(pointsScored) || pointsScored > 170) {
      if (outNotIn) {
        errorString = ("Impossible checkout inputed");
      } else {
        errorString = ("Impossible start score inputed");
      }
      return false;
    }
    return true;
  }

  Set<int> getPossibleDartsForCheckout(int checkoutScore) {
    if (checkoutScore != score) {
      return HashSet<int>.from([3]);
    }
    
    Set<int> onlyThreeDartOuts = HashSet<int>.from([109, 108, 106, 105, 104, 103, 102, 101, 99]);
    if (checkoutScore > 110 || onlyThreeDartOuts.contains(checkoutScore)) {
      return HashSet<int>.from([3]);
    } else if (checkoutScore != 50 && (checkoutScore > 40 || checkoutScore % 2 == 1)) {
      // On a 2-dart finish, if 2 shots are needed on the double, the checkout has to take 3 darts
      return HashSet<int>.from([2, 3]);
    } else {
      return HashSet<int>.from([1,2,3]);
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

  void combine(DartPlayer otherPlayer) {
    score = otherPlayer.score;
    legs += otherPlayer.legs;
    sets += otherPlayer.sets;
    stats = otherPlayer.stats;
  }


  DartBot createBotCopy() {
    DartBot copy = DartBot(name, rating);
    copy.stats = stats;
    return copy;
  }


  @override
  String toString() {
    return "($name, $rating)";
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


