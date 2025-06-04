// ignore_for_file: unnecessary_this

import 'DartPlayer.dart';
import 'MatchLogic.dart';


class MatchEngine {
  DartPlayer player1;
  DartPlayer player2;
  final MatchLogic matchRules;
  int onThrow = 2;
  int onThrowSet = 2;


  MatchEngine(this.player1, this.player2, this.matchRules);

  void newLeg() {
        this.player1.score = matchRules.getStartScore();
        this.player1.stats.dartsThrownLeg = 0;
        this.player2.score = matchRules.getStartScore();
        this.player2.stats.dartsThrownLeg = 0;
        if (this.onThrow == 1) {
            this.onThrow = 2;
        } else {
            this.onThrow = 1;
        }
        if (this.player1.legs == 0 && this.player2.legs == 0) {
            if (this.onThrowSet == 1) {
                this.onThrow = 2;
                this.onThrowSet = 2;
            } else {
                this.onThrow = 1;
                this.onThrowSet = 1;
            }
        }
    }

    void playLeg(bool ifQuickSim) {
        this.newLeg();
        int playerToThrow = this.onThrow;
        Scanner sc = new Scanner(System.in);
        while (this.player1.score > 0 && this.player2.score > 0) {
            if (playerToThrow == 1) {
                bool doubleInOpener = this.matchRules.ifDoubleIn() && this.player1.score == this.matchRules.getStartScore();
                this.player1.visitThrow(sc, this.matchRules.ifDoubleOut(), doubleInOpener);
                playerToThrow = 2;
            } else {
                bool doubleInOpener = this.matchRules.ifDoubleIn() && this.player2.score == this.matchRules.getStartScore();
                this.player2.visitThrow(sc, this.matchRules.ifDoubleOut(), doubleInOpener);
                playerToThrow = 1;
            }

            if (!ifQuickSim) {
                if (matchRules.isSetPlay) {
                    print(this.player1.toStringSetPlay());
                    print(this.player2.toStringSetPlay());
                } else {
                    print(this.player1.toString());
                    print(this.player2.toString());
                }
                print('');
            }
        }

        DartPlayer? hasWonLeg = this.ifWonLeg();
        if (hasWonLeg != null) {
            if (hasWonLeg.equals(this.player1)) {
                if (!ifQuickSim) print(this.player1.name + " has won the leg!");
                this.player1.updateBestWorstLegs();
            } else {
                if (!ifQuickSim) print(this.player2.name + " has won the leg!");
                this.player2.updateBestWorstLegs();
            }
            
            DartPlayer? hasWonSet = this.ifWonSet();
            if (hasWonSet != null) {
                if (hasWonSet.equals(this.player1)) {
                    if (!ifQuickSim) print(this.player1.name + " has won the set!");
                } else {
                    if (!ifQuickSim) print(this.player2.name + " has won the set!");
                }
            }
        } 

        if (!ifQuickSim) {
            if (matchRules.isSetPlay) {
                print(this.toStringSetPlay());
            } else {
                print(this.toString());
            }
        }
    }

  DartPlayer? ifWonSet() {
        if (!matchRules.isSetPlay) {
            return null;
        }

        if (this.player1.legs >= matchRules.getLegLimit()) {
            this.player1.sets++;
            this.player1.legs = 0;
            this.player2.legs = 0;
            return this.player1;
        } else if (this.player2.legs >= matchRules.getLegLimit()) {
            this.player2.sets++;
            this.player1.legs = 0;
            this.player2.legs = 0;
            return this.player2;
        }
        return null;
    }

    DartPlayer? ifWonLeg() {
        if (this.player1.score <= 0) {
            this.player1.legs++;
            this.player2.score = 0;
            return this.player1;
        } else if (this.player2.score <= 0) {
            this.player2.legs++;
            this.player1.score = 0;
            return this.player2;
        }

        return null;
    }

    DartPlayer? ifWinner(DartPlayer player) {
        if (matchRules.isSetPlay) {
            if (player.sets >= matchRules.getSetLimit()) {
                return player;
            } 
            return null;
        } else {
            if (player.legs >= matchRules.getLegLimit()) {
                return player;
            }
            return null;
        }
    }

    @override
    String toString() {
        return "Current Result:\nLeg|Scr\n(" + player1.legs.toString() + ") (" + player1.score.toString() + ") " + player1.name +
               "\n(" + player2.legs.toString() + ") (" + player2.score.toString() + ") " + player2.name;

        
    }

     String toStringSetPlay() {
        return "Current Result:\nSet|Leg|Scr\n("  + player1.sets.toString() + ") (" + player1.legs.toString() + ") (" + player1.score.toString() + ") " + player1.name +
               "\n(" + player2.sets.toString() + ") (" + player2.legs.toString() + ") (" + player2.score.toString() + ") " + player2.name;
    }

    @override
    bool operator ==(Object other) {
      if (identical(this, other)) return true;
      if (other is! MatchEngine) return false;
  
      return this.player1 == other.player1 &&
              this.player2 == other.player2 &&
              this.matchRules == other.matchRules;

    }

    @override
    int get hashCode {
      return this.player1.hashCode + this.player2.hashCode;
}


}