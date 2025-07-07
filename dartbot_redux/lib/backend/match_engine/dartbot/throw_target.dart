// ignore_for_file: unnecessary_this, file_names



import 'dart:math';

class ThrowTarget {
  int multiplier;
  int number;

  ThrowTarget(this.multiplier, this.number);

  String translateMultiplier() {
        if (this.multiplier == 3) {
            return "Treble";
        } else if (this.multiplier == 2 && this.number != 25) {
            return "Double";
        } else if (this.multiplier == 1) {
            return "Single";
        } else if (this.multiplier == 2 && this.number == 25) {
            return "Bullseye";
        }
        throw Exception("Illegal Multiplier located");
    }

    ThrowTarget getVariance(int dartsInHand, int scoreThisVisit) {
        // If its the first dart, no variance
        double rng = Random().nextDouble();
        switch (dartsInHand) {
            case 2:
                if ((scoreThisVisit == 60 && rng >= 0.8) || rng >= 0.5) {
                    this.number = 19; 
                }
            case 1:
                if ((scoreThisVisit == 120) && rng >= 0.9 || (0.3 <= rng && rng < 0.7)) {
                    this.number = 19;
                } else if (rng >= 0.70) {
                    this.number = 18;
                }
            default:
                return this;
        }
        return this;
    }

    @override
    String toString() {
        if ((this.number > 20 && this.number != 25) || this.number < 0) {
            throw Exception("Illegal Number Located");
        }
        if (this.multiplier == 3) {
            return "T$number";
        } else if (this.multiplier == 2 && this.number != 25) {
            return "D$number";
        } else if (this.multiplier == 1) {
            return "S$number";
        } else if (this.multiplier == 2 && this.number == 25) {
            return "BULL";
        }
        throw Exception("Illegal Multiplier located");
    }


    @override
    int get hashCode {
        return this.number + this.multiplier;
    }

    @override
    bool operator ==(Object other) {
      if (identical(this, other)) return true;
      if (other is! ThrowTarget) return false;
      return this.number == other.number 
          && this.multiplier == other.multiplier;

    }

}