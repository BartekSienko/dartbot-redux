// ignore_for_file: unnecessary_this


import 'dart:math';

import 'package:dartbot_redux/backend/match_engine/DartPlayer.dart';
import 'package:dartbot_redux/backend/match_engine/dartbot/DistributionTable.dart';
import 'package:dartbot_redux/backend/match_engine/dartbot/ThrowTarget.dart';

class DartBot extends DartPlayer {
    int dartsInHand;
    int scoreThisVisit;
    List<DistributionTable> distroTables;

  DartBot(super.name, super.rating) : 
    dartsInHand = 0,
    scoreThisVisit = 0,
    distroTables = [
      DistributionTable("Trebles", rating),
      DistributionTable("Doubles", rating),
      DistributionTable("Singles", rating),
      DistributionTable("Bullseye", rating),
    ];

    ThrowTarget getThrowTarget(bool isDoubleIn) {
        // Note: Bogey score => A score which cannot be taken out in 3 darts
        int remainingScore = this.score;
        if (isDoubleIn) {
            return ThrowTarget(2, 20);
        }
        
        if (this.dartsInHand == 3 && remainingScore % 3 == 0 && (123 <= remainingScore && remainingScore <= 129)) {
            // Aims for Treble 19 to leave (Treble + Bull) finish if it hits Single 19
            return ThrowTarget(3, 19); 
        } else if (this.dartsInHand == 3 && remainingScore % 3 == 2 && (122 <= remainingScore && remainingScore <= 128)) {
            // Aims for Treble 18 to leave (Treble + Bull) finish if it hits Single 18
            return ThrowTarget(3, 18); 
        } else if (this.dartsInHand == 2 && remainingScore % 3 == 2 && (101 <= remainingScore && remainingScore <= 110)) {
            // Aims for Treble (20,19,18,17) to leave Bull finish if it hits the aimed Treble
            return ThrowTarget(3, ((remainingScore - 50) / 3).round()); 
        } else if (remainingScore >= 190 || ((101 <= remainingScore && remainingScore <= 180) && remainingScore != 179)){
            // Aims for Treble 20 to get closer to a finish, potentially going for Treble 19 or 18
            ThrowTarget target = ThrowTarget(3, 20);
            target.getVariance(this.dartsInHand, this.scoreThisVisit);
            return target;
        } else if ((181 <= remainingScore && remainingScore <= 187) && remainingScore % 3 == 1) {
            // Aims for Treble 20 to get closer to a finish, , potentially going for Treble 19 or 18
            ThrowTarget target = ThrowTarget(3, 20);
            target.getVariance(this.dartsInHand, this.scoreThisVisit);
            return target;
        } else if (((183 <= remainingScore && remainingScore <= 189) && remainingScore % 3 == 0) || remainingScore == 179) {
            // Aims for Treble 19 as Single 20 would leave a bogey score
            return ThrowTarget(3, 19);
        } else if ((182 <= remainingScore && remainingScore <= 188) && remainingScore % 3 == 2) {
            // Aims for Treble 18 as Single 20/19 would leave a bogey score
            return ThrowTarget(3, 18);
        } else if (remainingScore == 99) {
            // Aims for Treble 19 to leave a (Single + Double) finish
            return ThrowTarget(3, 19);
        } else if (remainingScore == 80 || remainingScore == 77) {
            // Aims for Treble (20,19) to setup 'Double 10' finish
            return ThrowTarget(3, ((remainingScore - 20) / 3).round());
        } else if (remainingScore % 3 == 1 && (82 <= remainingScore && remainingScore <= 100)) {
            // Aims for Treble (20-14) to setup 'Double 20' finish
            return ThrowTarget(3, ((remainingScore - 40) / 3).round());
        } else if (remainingScore % 3 == 0 && (87 <= remainingScore && remainingScore <= 96)) {
            // Aims for Treble (20-17) to setup 'Double 18' finish
            return ThrowTarget(3, ((remainingScore - 36) / 3).round());
        } else if (remainingScore % 3 == 2 && (62 <= remainingScore && remainingScore <= 92)) {
            // Aims for Treble (20-10) to setup 'Double 16' finish
            return ThrowTarget(3, ((remainingScore - 32) / 3).round());
        } else if (remainingScore % 3 == 0 && (63 <= remainingScore && remainingScore <= 84)) {
            // Aims for Treble (20-13) to setup 'Double 12' finish
            return ThrowTarget(3, ((remainingScore - 24) / 3).round());
        } else if (remainingScore % 3 == 1 && (61 <= remainingScore && remainingScore <= 76)) {
            // Aims for Treble (20-15) to setup 'Double 8' finish
            return ThrowTarget(3, ((remainingScore - 16) / 3).round());
        } else if (remainingScore == 98 || remainingScore == 95) {
            // Aims for Treble (20,19) to setup 'Double 19'
            return ThrowTarget(3, ((remainingScore - 38) / 3).round());
        } else if (remainingScore == 79) {
            // Aims for Treble 19 to setup 'Double 11' leaves 60 for (Single + Double) finish if Single 19
            return ThrowTarget(3, 19);
        } else if (remainingScore == 50) {
            // Aims for bullseye
            return ThrowTarget(2, 25);
        } else if (remainingScore <= 40 && remainingScore % 2 == 0) {
            // Aims for Double(20-1) to finish the leg
            return ThrowTarget(2, (remainingScore / 2).round());
        } else if (57 <= remainingScore && remainingScore <= 60) {
            // Aims for Single(20-17) to leave 'Double 20' finish
            return ThrowTarget(1, (remainingScore - 40));
        } else if (53 <= remainingScore && remainingScore <= 56) {
            double doubleRNG = Random().nextDouble();
            int aimedDouble;
            // Decides on Double 20 or 18
            if (doubleRNG >= 0.5) { 
                aimedDouble = 40; 
            } else { 
                aimedDouble = 36;
            }
            // Aims at a Single to leave 'Double 20/18' finish
            return ThrowTarget(1, (remainingScore - aimedDouble));
        } else if (41 <= remainingScore && remainingScore <= 52) {
            double doubleRNG = Random().nextDouble();;
            int aimedDouble;
            // Decides on Double 20, 18 or 16
            if (doubleRNG >= 0.33) { 
                aimedDouble = 40; 
            } else if (doubleRNG >= 0.66) { 
                aimedDouble = 36;
            } else {
                aimedDouble = 32;
            }
            // Aims at a Single to leave 'Double 20/18/16' finish
            return ThrowTarget(1, (remainingScore - aimedDouble));
        }  else if (37 <= remainingScore && remainingScore <= 39) {
            double doubleRNG = Random().nextDouble();
            int aimedDouble;
            // Decides on Double 18 or 16
            if (doubleRNG >= 0.5) { 
                aimedDouble = 36; 
            } else { 
                aimedDouble = 32;
            }
            // Aims at a Single to leave 'Double 18/16' finish
            return ThrowTarget(1, (remainingScore - aimedDouble));
        } else if (33 <= remainingScore && remainingScore <= 35) {
            double doubleRNG = Random().nextDouble();
            int aimedDouble;
            // Decides on Double 16 or 12
            if (doubleRNG >= 0.5) { 
                aimedDouble = 32; 
            } else { 
                aimedDouble = 24;
            }
            // Aims at a Single to leave 'Double 16/12' finish
            return ThrowTarget(1, (remainingScore - aimedDouble));
        } else if (25 <= remainingScore && remainingScore <= 31) {
            double doubleRNG = Random().nextDouble();
            int aimedDouble;
            // Decides on Double 12 or 8
            if (doubleRNG >= 0.5) { 
                aimedDouble = 24; 
            } else { 
                aimedDouble = 16;
            }
            // Aims at a Single to leave 'Double 12/8' finish
            return ThrowTarget(1, (remainingScore - aimedDouble));
        } else if (17 <= remainingScore && remainingScore <= 23) {
            // Aims at a Single(7-1) to leave 'Double 8' finish
            return ThrowTarget(1, (remainingScore - 16));
        } else if (9 <= remainingScore && remainingScore <= 15) {
            // Aims at a Single(7-1) to leave 'Double 4' finish
            return ThrowTarget(1, (remainingScore - 8));
        } else if (5 <= remainingScore && remainingScore <= 7) {
            // Aims at a Single(3-1) to leave 'Double 2' finish
            return ThrowTarget(1, (remainingScore - 4));
        } else if (remainingScore == 3) {
            // Aims at Single 1 to leave 'Double 1' finish
            return ThrowTarget(1, 1);
        }
        // If somehow a ThrowTarget wasn't found, throw a RuntineException
        throw Exception("Didn't create target for score: " + this.score.toString() + " with " + this.dartsInHand.toString() + " darts left");
    }
}



