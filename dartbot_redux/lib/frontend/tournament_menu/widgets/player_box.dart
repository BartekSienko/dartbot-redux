// ignore_for_file: file_names


import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/tournaments/tour_match.dart';
import 'package:dartbot_redux/backend/tournaments/tournament.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:flutter/material.dart';

class PlayerBox extends StatefulWidget{
  final MatchTheme matchTheme;
  final double height;
  final Tournament tournament;
  final DartPlayer? focusPlayer;
  final VoidCallback onReload;

  
  const PlayerBox( {
    super.key,
    required this.matchTheme,
    required this.height,
    required this.tournament,
    required this.onReload,
    this.focusPlayer
  });

  @override
  State<PlayerBox> createState() => _PlayerBoxState();
  
}

class _PlayerBoxState extends State<PlayerBox> {
  late MatchTheme matchTheme;
  late double height;
  late Tournament tournament;
  late DartPlayer? focusPlayer;
  late VoidCallback onReload;
  

  @override
  void initState() {
    super.initState();
    matchTheme = widget.matchTheme;
    height = widget.height;
    tournament = widget.tournament;
    focusPlayer = widget.focusPlayer;
    onReload = widget.onReload;

  }

  TourMatch getFocusMatch() {
    if (focusPlayer != null) {
      List<DartPlayer> curRoundPlayers = tournament.players[tournament.curRoundNr];
      List<TourMatch> curRound = tournament.rounds[tournament.curRoundNr];
      int roundPlayerCount = curRoundPlayers.length;
      int playerIndex = curRoundPlayers.indexOf(focusPlayer!);

      if (playerIndex < (roundPlayerCount/2)) {
        return curRound[playerIndex];
      } else {
        return curRound[(curRound.length - 1 - playerIndex)];
      }
    } else {
      List<TourMatch> curRound = tournament.rounds[tournament.curRoundNr];
      for (int matchNr = 0; matchNr < curRound.length; matchNr++) {
        if (!curRound[matchNr].ifPlayed) {
          return curRound[matchNr];
        }
      }
      return curRound.last;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth / 28;

    TourMatch focusMatch = getFocusMatch();

    return Container(
      decoration: BoxDecoration(
        color: matchTheme.secondaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          ),
        ),

      child: SizedBox.expand(
        child: Row(
          children: [
            Expanded(
              flex: 40,
              child: buildMatchText(focusMatch, fontSize),
            ),
            Expanded(
              flex: 20,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: SizedBox(
                  height: height * 0.50, // 🔽 Set desired max height here
                  child: buildButton(
                    "PLAY\nMATCH",
                    fontSize,
                    () async {
                      if (!focusMatch.ifPlayed) {
                        List<String>? playersStatus = await getPlayersStatus(2);
                        if (playersStatus != null) {
                          // ignore: use_build_context_synchronously
                          await tournament.playMatch(focusMatch, playersStatus[0], playersStatus[1], context);
                          onReload();
                          setState(() {});
                        }
                        
                      }
                    }
                  )
                )
              )
            ),
            Expanded(
            flex: 20,
            child: SizedBox(
                height: height * 0.50, // 🔽 Set desired max height here
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 2.0),
                  child: buildButton(
                    "SIM\nROUND",
                    fontSize,
                    () => {
                      if (!focusMatch.ifPlayed) {
                        tournament.simRound(context),
                        onReload(),
                        setState(() {})
                      }
                    }
                  )
                )
              )
            ),
            
            Expanded(
              flex: 20,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: SizedBox(
                  height: height * 0.50, // 🔽 Set desired max height here
                  child: buildButton(
                    "NEXT\nROUND",
                    fontSize,
                    () {
                      if (tournament.allMatchesFinished()) {
                        tournament.curRoundNr++;
                        if (tournament.isFinished()) {
                          Navigator.of(context).pop();       // pop the page
                          displayTournamentResults(context, fontSize);
                        } else {
                          tournament.rounds.add(tournament.generateRound());
                          onReload();
                          setState(() {});
                        }
                        
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Center(child: Text('Not All Matches Have Been Played')),
                              actions: [
                                TextButton(
                                  child: Text('Close'),
                                  
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop(); // close the dialog       // pop the page
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  )
                )
              )
            ),
        ],
        )
      )
    );
  }

  

  Widget buildMatchText(TourMatch focusMatch, double fontSize) {
    return Padding(
      padding: EdgeInsets.all(fontSize / 8), // Optional padding
      child: Column(
        children: [
          Text(
            "Next Match: (Nr# ${tournament.rounds[tournament.curRoundNr].indexOf(focusMatch) + 1})",
            style: TextStyle(fontWeight: FontWeight.bold,
                             color: matchTheme.backgroundColor,
                             fontSize: fontSize),
            textAlign: TextAlign.left,
          ),
          Text(
            focusMatch.player1.name,
            style: TextStyle(color: matchTheme.backgroundColor,
                             fontSize: fontSize,),
            textAlign: TextAlign.left,
          ),
          Text(
            "vs",
            style: TextStyle(color: matchTheme.backgroundColor,
                             fontSize: fontSize),
            textAlign: TextAlign.left,
          ),
          Text(
            focusMatch.player2.name,
            style: TextStyle(color: matchTheme.backgroundColor,
                             fontSize: fontSize),
            textAlign: TextAlign.left,
          )
        ],
      )
    );
  }


  Widget buildButton(
    String label,
    double fontSize,
    Function() onPressed
  ) {
    return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: matchTheme.mainBoxColor,
            minimumSize: Size(double.infinity, fontSize * 3), // Ensures button doesn't force a size
            padding: EdgeInsets.zero, // Optional: tighten button space
          ),
          
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            
            child: Center(
              child: Text(label, 
                          style: TextStyle(fontSize: fontSize, color: matchTheme.mainBoxTextColor),
                          textAlign: TextAlign.center,))
            )
        );

  }

  Future<List<String>?> getPlayersStatus(int playerCount) async {
  return await showDialog<List<String>>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: matchTheme.secondaryColor,
        title: const Center(child: Text('Select Match Option:')),
        content: Column(
          mainAxisSize: MainAxisSize.min, // important for sizing
          children: [
            buildButton(
              "Player vs Player",
              16,
              () {
                Navigator.of(dialogContext).pop(['player', 'player']);
              },
            ),
            SizedBox(height: height / 150, child: Container(color: matchTheme.secondaryColor),),
            buildButton(
              "Player vs Bot",
              16,
              () {
                Navigator.of(dialogContext).pop(['player', 'bot']);
              },
            ),
            SizedBox(height: height / 150, child: Container(color: matchTheme.secondaryColor),),
            buildButton(
              "Bot vs Player",
              16,
              () {
                Navigator.of(dialogContext).pop(['bot', 'player']);
              },
            )
            
          ],
        ),
      );
    },
  );
  }
  
  void displayTournamentResults(BuildContext context, double fontSize){
    showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Center(child: Text('Match Stats')),
        content: generateTournamentResults(fontSize),
        actions: [
          TextButton(
            child: Text('Close'),
            
            onPressed: () {
              Navigator.of(dialogContext).pop(); // close the dialog
            },
          ),
        ],
      );
    },
  );
  }

  Widget generateTournamentResults(double fontSize) {
  int roundCount = tournament.eliminated.length;

  List<String> roundNames = [];
  for (int i = 0; i < (roundCount - 3); i++) {
    roundNames.add("----- Round #${ i + 1 } -----");
  }
  roundNames.add("----- Quarter-Final -----");
  roundNames.add("----- Semi-Final -----");
  roundNames.add("----- Runner-Up -----");

  return SizedBox(
    height: 300, // or MediaQuery.of(context).size.height * 0.5
    width: 300,  // optional, based on layout
    child: ListView(
      shrinkWrap: true,
      children: [
      Text(
        "----- Winner ----",
        style: TextStyle(
            color: matchTheme.backgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
      ),
      Text(
        tournament.players.last[0].name,
              style: TextStyle(
                color: matchTheme.backgroundColor,
                fontSize: fontSize,
              ),
      ),

      // All eliminated players
      for (int roundNr = roundCount - 1; roundNr >= 0; roundNr--) ...[
        Text(
          roundNames[roundNr],
          style: TextStyle(
            color: matchTheme.backgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
        ...tournament.eliminated[roundNr].map((player) => Text(
              player.name,
              style: TextStyle(
                color: matchTheme.backgroundColor,
                fontSize: fontSize,
              ),
            )),
        ],
      ],
    )
  );
}


}