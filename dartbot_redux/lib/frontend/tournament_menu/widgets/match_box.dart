// ignore_for_file: file_names


import 'package:dartbot_redux/backend/tournaments/tournament.dart';
import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:dartbot_redux/frontend/tournament_menu/widgets/match_list.dart';
import 'package:flutter/material.dart';

class MatchBox extends StatefulWidget{
  final MatchTheme matchTheme;
  final double height;
  final Tournament tournament;
  final VoidCallback onReload;

  
  const MatchBox({
    super.key,
    required this.matchTheme,
    required this.height,
    required this.tournament,
    required this.onReload
  });

  @override
  State<MatchBox> createState() => _MatchBoxState();
  
}

class _MatchBoxState extends State<MatchBox> {
  late MatchTheme matchTheme;
  late Tournament tournament;
  late double height;
  late VoidCallback onReload;

  @override
  void initState() {
    super.initState();
    matchTheme = widget.matchTheme;
    tournament = widget.tournament;
    height = widget.height;
    onReload = widget.onReload;

  }
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;



    return Container(
      decoration: BoxDecoration(
        color: matchTheme.mainColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
    
      child: SizedBox(
        height: height,
        child: Column(
          children: [
              SizedBox( 
              height: height * 0.1,
              child: buildRoundText(screenWidth)
              ),
              SizedBox( 
              height: height * 0.86,
              child: MatchList(matchTheme: matchTheme,
                               height: height,
                               tournament: tournament,
                               onReload: onReload)
              ),
              SizedBox( 
              height: height * 0.04,
              child: Container(
                decoration: BoxDecoration(
                  color: matchTheme.mainBoxColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                    ),
                  ),

              )
              ),
            ],
         )
      )
    );

      
  }


  Widget buildRoundText(double screenWidth) {
    double fontSize = screenWidth / 20;

    String roundName = tournament.getRoundName();


    return Container(
      decoration: BoxDecoration(
        color: matchTheme.mainBoxColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          ),
        ),
        child: Center(
          child: Text(
            roundName,
            style: TextStyle(
              color: matchTheme.mainBoxTextColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize
            ),
          )
        )
    );
  }


}