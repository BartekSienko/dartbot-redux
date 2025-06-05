// ignore_for_file: unnecessary_this

import 'dart:io';

class MatchLogic {
  final int startScore;
  final int legLimit;
  bool isSetPlay;
  final int setLimit;
  final bool doubleOut;
  final bool doubleIn;

  MatchLogic(this.startScore, this.legLimit, this.isSetPlay, this.setLimit, this.doubleOut, this.doubleIn);

  /// TODO: Remove stub .fromInput when its connected with frontend
  MatchLogic.fromInput() :
    startScore = _getPosInt('Input Leg Length (Ex. 501 / 301 / At least 101): ', 101),
    legLimit = _getPosInt('Input Leg Amount (First to "x" legs wins): ', 1),
    setLimit = _getPosInt('Input Set amount (First to "x" sets wins, "0" if no set-play): ', 0),
    isSetPlay =  false, /// FIXME: Stub to be able to use the file
    doubleOut = _getYesOrNo('Double-Out? (Input "Y" or "N"): '),
    doubleIn = _getYesOrNo('Double-In? (Input "Y" or "N"): ');


  static int _getPosInt(String prompt, int minLimit) {
    int input = -1;
    while (input < minLimit) {
      stdout.write(prompt);
      String? line = stdin.readLineSync();
      if (line != null && int.tryParse(line) != null) {
        input = int.parse(line);
      }
    }
    return input;
  }

  static bool _getYesOrNo(String prompt) {
    String input = '';
    while (input != 'Y' && input != 'N') {
      stdout.write(prompt);
      input = stdin.readLineSync()?.toUpperCase() ?? '';
    }
    return input == 'Y';
  }

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

