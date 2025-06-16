// ignore_for_file: unnecessary_this, file_names

import 'package:collection/collection.dart';

class PlayerMatchStats {
  List<int> scores;
  List<int> first9scores;
  List<int> checkouts;
  int dartsThrown;
  int dartsThrownLeg;
  int doublesAttempted;
  int doublesSucceeded;
  int bestLeg;
  int worstLeg;

  PlayerMatchStats()
      : scores = [],
        first9scores = [],
        checkouts = [],
        dartsThrownLeg = 0,
        dartsThrown = 0,
        doublesAttempted = 0,
        doublesSucceeded = 0,
        bestLeg = 0,
        worstLeg = 0;

  void addScore(int pointsScored, int dartsThrown) {
    scores.add(pointsScored);
    if (dartsThrownLeg < 9) {
      first9scores.add(pointsScored);
    }
    this.dartsThrown += dartsThrown;
    dartsThrownLeg += dartsThrown;
  }

  void addCheckout(int pointsScored, int dartsAtCheckout) {
    scores.add(pointsScored);
    if (dartsThrownLeg < 9) {
      first9scores.add(pointsScored);
    }
    doublesSucceeded++;
    this.dartsThrown += dartsAtCheckout;
    dartsThrownLeg += dartsAtCheckout;
    checkouts.add(pointsScored);
  }

  double getListAverage(List<int> list) {
  double sum = 0;
  for (int i in list) {
    sum += i;
  }
  if (list == first9scores) {
    return (sum / list.length * 10.0).round() / 10.0;
  }
  return (sum / dartsThrown * 30.0).round() / 10.0;
}

String getCheckoutSplit() {
  return '$doublesSucceeded/$doublesAttempted';
}

double getCheckoutRate() {
  if (doublesAttempted == 0) {
    return 0;
  }
  return ((doublesSucceeded / doublesAttempted) * 10000).round() / 100.0;
}

int getHighestFromList(List<int> list) {
  int highest = 0;
  for (int i in list) {
    if (highest < i) {
      highest = i;
    }
  }
  return highest;
}

@override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlayerMatchStats) return false;

    bool scoresCheck = ListEquality().equals(scores, other.scores);
    bool first9scoresCheck = ListEquality().equals(first9scores, other.first9scores);
    bool checkoutsCheck = ListEquality().equals(checkouts, other.checkouts);
    bool dartsThrownCheck = dartsThrown == other.dartsThrown;
    bool doublesAttemptedCheck = doublesAttempted == other.doublesAttempted;
    bool doublesSucceededCheck = doublesSucceeded == other.doublesSucceeded;
    bool bestLegCheck = bestLeg == other.bestLeg;
    bool worstLegCheck = worstLeg == other.worstLeg;

    return scoresCheck && first9scoresCheck && checkoutsCheck && dartsThrownCheck &&
           doublesAttemptedCheck && doublesSucceededCheck && bestLegCheck && worstLegCheck;
  }

  @override
  int get hashCode {
    return scores.hashCode + checkouts.hashCode + dartsThrown +
           doublesAttempted + doublesSucceeded;
  }

  @override
  String toString() {
    return "\n3-dart Average: ${getListAverage(scores)}\nFirst 9 avr.: ${getListAverage(first9scores)}" 
           "\nCheckout Rate: ${getCheckoutRate()} %\nCheckouts: ${getCheckoutSplit()}"
           "\nHighest Score: ${getHighestFromList(scores)}\nHighest Checkout: ${getHighestFromList(checkouts)}"
           "\nBest Leg: $bestLeg darts\nWorst Leg: $worstLeg darts";
  }
  
}

