// ignore_for_file: file_names, avoid_print

// THIS FILE WILL BE REMOVED, ONLY USED DURING DIRECT TRANSLATION
import 'dart:io';

import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/dartbot/dart_bot.dart';
import 'package:dartbot_redux/backend/match_engine/match_driver.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';

//import 'tournament.dart';

class StubTerminalMenu {
  int input = -1;

  void printMainMenu() {
    print("-----------------");
    String str = "1) Play a match\n" 
                 "2) New Tournament\n"
                 "3) Load Tournament\n"
                 "4) New Career Mode\n"
                 "5) Load Career Mode\n"
                 "0) Quit\n";
    print(str);
  }

  void handleMainMenu() {
    if (input == 1) {
      setupMatch();
    } else if (input == 2) {
      // menuSetupTournament();
    } else if (input == 3) {
      print("-----------------");
      // menuLoadTournament();
    } else if (input == 4) {
      // Handle new career mode
    } else if (input == 5) {
      // Handle load career mode
    }
  }

  void mainMenu() {
    while (input != 0) {
      printMainMenu();
      stdout.write("Input Option: ");
      input = getIntInRange(0, 4);
      handleMainMenu();
    }
  }

  void setupMatch() {
    String str = "1) Player vs Player\n"
                 "2) Player vs Bot\n"
                 "3) Bot vs Player\n"
                 "4) Bot vs Bot\n";
    print(str);
    input = getIntInRange(1, 4);
    DartPlayer player1;
    DartPlayer player2;

    stdout.write("Input Player 1 name: ");
    String p1Name = stdin.readLineSync()!;
    if (input == 1 || input == 2) {
      player1 = DartPlayer(p1Name, 100);
    } else {
      stdout.write("Input Player 1 Rating (0-100): ");
      int rating = getIntInRange(0, 100);
      player1 = DartBot(p1Name, rating.toDouble());
    }
    stdout.write("Input Player 2 name: ");
    String p2Name = stdin.readLineSync()!;
    if (input == 1 || input == 3) {
      player2 = DartPlayer(p2Name, 100);
    } else {
      stdout.write("Input Player 2 Rating (0-100): ");
      int rating = getIntInRange(0, 100);
      player2 = DartBot(p2Name, rating.toDouble());
    }

    MatchLogic rules = MatchLogic.fromInput();
    MatchDriver match = MatchDriver(player1, player2, rules);
    match.runMatch(false);
  }

  int getIntInRange(int minLimit, int maxLimit) {
    int input = -1;
    while (input < minLimit || input > maxLimit) {
      String? line = stdin.readLineSync();
      if (line != null && int.tryParse(line) != null) {
        input = int.parse(line);
      }
    }
    return input;
  }

}

  void main(List<String> args) {
    StubTerminalMenu menu = StubTerminalMenu();
    menu.mainMenu();
  }
