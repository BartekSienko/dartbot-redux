

import 'dart:convert';
import 'dart:io';
import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/match_logic.dart';
import 'package:dartbot_redux/backend/tournaments/tour_match.dart';
import 'package:dartbot_redux/backend/tournaments/tournament.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:path_provider/path_provider.dart';

class JsonManager {




  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getTournamentFile(String tournamentName) async {
    final path = await _localPath;
    return File('$path/$tournamentName.json');
  }

  Future<File> saveTournament(Tournament tournament) async {
  final file = await getTournamentFile(tournament.name);
  String str = getTournamentString(tournament);
  print('Writing to $file');
  // Write the file
  return file.writeAsString(str);
}

  String getTournamentString(Tournament tournament) {
    String saveData = "";

    saveData = '$saveData "name": "${tournament.name}",\n';
    saveData = '$saveData "tag": "${tournament.tag}",\n';
    saveData = '$saveData "matchTheme": "${tournament.matchTheme.name}",\n';
    saveData = '$saveData "playerCount": ${tournament.playerCount},\n';
    saveData = '$saveData "players": ${getValuesFromDoubleList(tournament.players)},\n';
    saveData = '$saveData "rounds": ${getValuesFromDoubleList(tournament.rounds)},\n';
    saveData = '$saveData "eliminated": ${getValuesFromDoubleList(tournament.eliminated)},\n';
    saveData = '$saveData "rulesets": ${getValuesFromList(tournament.rulesets)},\n';
    saveData = '$saveData "prizeMoney": ${getValuesFromList(tournament.prizeMoney)},\n';
    saveData = '$saveData "curRoundNr": ${tournament.curRoundNr},\n';
    saveData = '$saveData "lastWinner": "${tournament.lastWinner}"';


    return '{\n $saveData\n }';
  }


  String getValuesFromDoubleList(List<List<dynamic>> doubleList) {
    String saveData  = '';

    int length = doubleList.length;

    if (length < 1) return '{}';
    for (int i = 0; i < length; i++) {
        saveData = '$saveData "$i": ${getValuesFromList(doubleList[i])},';
    }
    saveData = saveData.substring(0, saveData.length - 1);

    
    return '{\n $saveData\n }';
  }

  String getValuesFromList(List<dynamic> list) {
    String saveData  = '';
    int length = list.length;

    for (int i = 0; i < length; i++) {
      if (i > 0) saveData = '$saveData,'; //Adds ',' after first
      saveData = '$saveData "${list[i].toString()}"';
    }

    return '\n[$saveData]\n';
  }


  Future<Tournament> loadTournamentFromFile(String tournamentName) async {
  
  final File file = await getTournamentFile(tournamentName);
  final String contents = await file.readAsString();
  final Map<String,dynamic> jsonMap = jsonDecode(contents);
  return generateTournamentfromJSON(jsonMap);
  }

  Tournament generateTournamentfromJSON(Map<String, dynamic> jsonMap) {
  String name = jsonMap['name'];
  String tag = jsonMap['tag'];
  MatchTheme matchTheme = MatchTheme(jsonMap['matchTheme']);
  int playerCount = jsonMap['playerCount'];

  // PLAYERS
  Map<String, dynamic> playersMap = jsonMap['players'];
  List<List<DartPlayer>> players = playersMap.values.map<List<DartPlayer>>((roundList) {
    return (roundList as List).map<DartPlayer>((playerString) {
      return DartPlayer.fromString(playerString);
    }).toList();
  }).toList();

  // ELIMINATED
  Map<String, dynamic> eliminatedMap = jsonMap['eliminated'];
  List<List<DartPlayer>> eliminated = eliminatedMap.values.map<List<DartPlayer>>((elimList) {
    return (elimList as List).map<DartPlayer>((playerString) {
      return DartPlayer.fromString(playerString);
    }).toList();
  }).toList();

  // ROUNDS
  Map<String, dynamic> roundsMap = jsonMap['rounds'];
  List<List<TourMatch>> rounds = roundsMap.values.map<List<TourMatch>>((roundList) {
    return (roundList as List).map<TourMatch>((matchString) {
      return TourMatch.fromString(matchString);
    }).toList();
  }).toList();

  // RULESETS
  List<dynamic> rulesetsList = jsonMap['rulesets'];
  List<MatchLogic> rulesets = rulesetsList.map<MatchLogic>((ruleString) {
    return MatchLogic.fromString(ruleString);
  }).toList();

  // MONEY
  List<dynamic> moneyList = jsonMap['prizeMoney'];
  List<int> prizeMoney = moneyList.map<int>((m) => int.parse(m)).toList();

  Tournament t = Tournament(name, tag, matchTheme, playerCount, players,rulesets,prizeMoney,jsonMap['lastWinner']);

  t.eliminated = eliminated;
  t.rounds = rounds;
  t.curRoundNr = jsonMap['curRoundNr'];
  return t;
}




}