// ignore_for_file: unnecessary_this, file_names

class MatchLogic {
  final int startScore;
  final int legLimit;
  bool isSetPlay;
  final int setLimit;
  final bool doubleOut;
  final bool doubleIn;

  MatchLogic(this.startScore, this.legLimit, this.isSetPlay, this.setLimit, this.doubleOut, this.doubleIn);


  int getStartScore() {
    return startScore;
  }

  int getLegLimit() {
    return legLimit;
  }

  int getSetLimit() {
    return setLimit;
  }

  bool ifDoubleOut() {
    return doubleOut;
  }

  bool ifDoubleIn() {
    return doubleIn;
  }

  @override
  bool operator ==(Object other) {
    if (other is MatchLogic) {
      return startScore == other.startScore &&
             legLimit == other.legLimit &&
             isSetPlay == other.isSetPlay &&
             setLimit == other.setLimit &&
             doubleOut == other.doubleOut &&
             doubleIn == other.doubleIn;
    }
    return false;
  }

  @override
  int get hashCode {
    return startScore + legLimit;
  }
}

