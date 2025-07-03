



import 'package:flutter/material.dart';

class MatchTheme {
  late Color mainColor;
  late Color secondaryColor;
  late Color backgroundColor;
  late Color mainBoxColor;
  late Color nameBoxColor;
  late Color mainBoxTextColor;
  late Color nameBoxTextColor;

  MatchTheme(String themeText) {
    if (themeText == 'WC') {
      mainColor = const Color.fromARGB(255, 59, 120, 62); 
      secondaryColor = const Color.fromARGB(255, 190, 190, 51);
      backgroundColor = const Color.fromARGB(255, 30, 52, 31);
      mainBoxColor = const Color.fromARGB(255, 59, 120, 62); 
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Masters') {
      mainColor = Colors.purple;
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 89, 22, 101);
      mainBoxColor = Colors.purple;
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'UK') {
      mainColor = Colors.red; 
      secondaryColor = const Color.fromARGB(255,255,255,255);
      backgroundColor = const Color.fromARGB(255, 24, 40, 92);
      mainBoxColor = const Color.fromARGB(255, 44, 71, 158); 
      nameBoxColor = const Color.fromARGB(255, 255, 255, 255);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Matchplay') {
      mainColor = const Color.fromARGB(255, 59, 120, 62); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 30, 52, 31);
      mainBoxColor = const Color.fromARGB(255, 59, 120, 62); 
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'GrandPrix') {
      mainColor = const Color.fromARGB(255, 44, 71, 158); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 24, 40, 92);
      mainBoxColor = const Color.fromARGB(255, 44, 71, 158); 
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'GrandSlam') {
      mainColor = const Color.fromARGB(255, 59, 120, 62); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 30, 52, 31);
      mainBoxColor = const Color.fromARGB(255, 165, 165, 44);
      nameBoxColor = const Color.fromARGB(255, 255, 255, 255); 
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Euro') {
      mainColor = const Color.fromARGB(255, 44, 71, 158); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 24, 40, 92);
      mainBoxColor = const Color.fromARGB(255, 44, 71, 158); 
      nameBoxColor = const Color.fromARGB(255, 87, 103, 158);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 255, 255, 255);

    } else if (themeText == 'Euro+') {
      mainColor = const Color.fromARGB(255, 44, 71, 158); 
      secondaryColor = const Color.fromARGB(255, 190, 190, 51);
      backgroundColor = const Color.fromARGB(255, 24, 40, 92);
      mainBoxColor = const Color.fromARGB(255, 44, 71, 158); 
      nameBoxColor = const Color.fromARGB(255, 87, 103, 158);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 255, 255, 255);

    } else if (themeText == 'PC') {
      mainColor = Colors.red; 
      secondaryColor = const Color.fromARGB(255,255,255,255);
      backgroundColor = const Color.fromARGB(255, 80, 0, 0);
      mainBoxColor = const Color.fromARGB(255, 0, 0, 0);
      nameBoxColor = const Color.fromARGB(255, 255, 255, 255);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'PC+') {
      mainColor = Colors.red; 
      secondaryColor = const Color.fromARGB(255,255,255,255);
      backgroundColor = const Color.fromARGB(255, 80, 0, 0);
      mainBoxColor = const Color.fromARGB(255, 150, 0, 0);
      nameBoxColor = const Color.fromARGB(255, 255, 255, 255);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Prem') {
      mainColor = const Color.fromARGB(255, 59, 120, 62); 
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 89, 22, 101);
      mainBoxColor = Colors.purple;
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else if (themeText == 'Reg') {
      mainColor = Colors.cyan;
      secondaryColor = const Color.fromARGB(255, 255, 255, 255);
      backgroundColor = const Color.fromARGB(255, 53, 117, 125);
      mainBoxColor = Colors.cyan;
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);

    } else { // default values
      mainColor = Colors.green; 
      secondaryColor = Colors.white;
      backgroundColor = const Color.fromARGB(255, 47, 83, 49);
      mainBoxColor = Colors.green; 
      nameBoxColor = const Color.fromARGB(255, 220, 220, 220);
      mainBoxTextColor = const Color.fromARGB(255, 255, 255, 255);
      nameBoxTextColor = const Color.fromARGB(255, 0, 0, 0);
    }
  }



}