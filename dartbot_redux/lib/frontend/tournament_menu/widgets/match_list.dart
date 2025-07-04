// ignore_for_file: file_names


import 'package:dartbot_redux/backend/match_engine/dart_player.dart';
import 'package:dartbot_redux/backend/match_engine/player_match_stats.dart';
import 'package:dartbot_redux/backend/tournaments/tournament.dart';
import 'package:dartbot_redux/backend/tournaments/tour_match.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:flutter/material.dart';

class MatchList extends StatefulWidget{
  final MatchTheme matchTheme;
  final double height;
  final Tournament tournament;
  final VoidCallback onReload;


  
  const MatchList({
    super.key,
    required this.matchTheme,
    required this.tournament,
    required this.height,
    required this.onReload
    
  });

  @override
  State<MatchList> createState() => _MatchListState();
  
}

class _MatchListState extends State<MatchList> {
  late MatchTheme matchTheme;
  late double height;
  late Tournament tournament;
  late VoidCallback onReload;

  @override
  void initState() {
    super.initState();
    matchTheme = widget.matchTheme;
    height = widget.height;
    tournament = widget.tournament;
    onReload = widget.onReload;

  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth / 25;
    
    List<TourMatch> currentRound = tournament.rounds[tournament.curRoundNr];



    return Container(
      decoration: BoxDecoration(
        color: matchTheme.mainColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
    
        child: ListView(
          padding: EdgeInsets.zero,

          children: [
            for (int i = 0; i < currentRound.length; i++) ...[
              SizedBox(height: height / 200, child: Container(color: matchTheme.secondaryColor),),
              buildListedMatch(currentRound[i], fontSize),
            ],
            SizedBox(height: height / 200, child: Container(color: matchTheme.secondaryColor),)
          ],
        )

       
        
    
    );

      
  }

  Widget buildListedMatch(TourMatch match, double fontSize) {
    return Container(
      color: matchTheme.nameBoxColor,

      child: Row(
        children: [
          Expanded(
            flex: 70,
            child: Column(
              children: [
                buildPlayerRow(match, match.player1, fontSize),
                buildPlayerRow(match, match.player2, fontSize)
              ],
            )
          ),
          // TODO: Stub, supposed to be a button
          Expanded(
            flex: 15,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 2.0),
              child: buildButton(
                "SIM",
                fontSize,
                () => {
                  if (!match.ifPlayed) {
                    tournament.playMatch(match, 'bot', 'bot', context),
                    onReload(),
                    setState(() {})
                  }
                }
              )
            )
          ),
        // TODO: Stub, supposed to be a button
          Expanded(
            flex: 15,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: buildButton(
                "PLAY",
                fontSize,
                () async {
                  if (!match.ifPlayed) {
                    List<String>? playersStatus = await getPlayersStatus(2);
                    if (playersStatus != null) {
                      // ignore: use_build_context_synchronously
                      await tournament.playMatch(match, playersStatus[0], playersStatus[1], context);
                      onReload();
                      setState(() {});
                    }
                    
                  }
                }
              )
            )
          ),
        ],
      )
        
    );
  }

  Row buildPlayerRow(TourMatch match, DartPlayer player, double fontSize) {
    TextStyle style;
    if ((match.player1 == player && match.winner == 1) ||
        (match.player2 == player && match.winner == 2)) {
      style = TextStyle(color: matchTheme.nameBoxTextColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold);
    } else {
      style = TextStyle(color: matchTheme.nameBoxTextColor,
                        fontSize: fontSize);
    }

    
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: buildPlayerText(player, fontSize, style)
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              player.legs.toString(),
              style: style,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }

  Padding buildPlayerText(DartPlayer player, double fontSize, TextStyle style) {
    PlayerMatchStats stats = player.stats;

    Color textColor = matchTheme.nameBoxTextColor;
    Color averageTextColor = textColor.withAlpha(100);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: style,
          children: [
            TextSpan(
              text: "${player.name} \t",
              style: style.copyWith(color: textColor),
            ),
            TextSpan(
              text: "(${stats.getListAverage(stats.scores)} avr)",
              style: style.copyWith(color: averageTextColor),
            ),
          ],
        ),
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
              child: Text(label, style: TextStyle(fontSize: fontSize, color: matchTheme.mainBoxTextColor),))
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
  
}