// ignore_for_file: file_names


import 'package:dartbot_redux/frontend/match_menu/widgets/match_theme.dart';
import 'package:flutter/material.dart';

class InfoBox extends StatefulWidget{
  final MatchTheme matchTheme;
  final double height;

  
  const InfoBox({
    super.key,
    required this.matchTheme,
    required this.height
  });

  @override
  State<InfoBox> createState() => _InfoBoxState();
  
}

class _InfoBoxState extends State<InfoBox> {
  late MatchTheme matchTheme;
  late double height;

  @override
  void initState() {
    super.initState();
    matchTheme = widget.matchTheme;
    height = widget.height;

  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: matchTheme.secondaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          ),
        ),

      child: SizedBox.expand(
        child: Center(child: Table(
          children: [
            TableRow(
              children: [
              buildInfoText("Current Round: ", "1"),
              buildInfoText("Players: ", "32")
              ]
            ),
            TableRow(
              children: [
              buildInfoText("Winner's Prize: ", "120.000"),
              buildInfoText("Last Winner: ", "Gwen (3)")
              ]
            )
          ],
        ))
      )
    );
  }

  Widget buildInfoText(String bold, String regular) {
    return Padding(
      padding: EdgeInsets.all(28 / 2), // Optional padding
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: matchTheme.backgroundColor, fontSize: 16),
          children: [
            TextSpan(
              text: bold,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: regular,
            ),
          ],
        ),
      )
    );
  }

}