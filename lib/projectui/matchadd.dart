import 'package:badmintontournament/projectui/matches.dart';
import 'package:badmintontournament/provider/matchprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchAdd extends StatefulWidget {
  const MatchAdd({super.key});

  @override
  State<MatchAdd> createState() => _MatchAddState();
}

class _MatchAddState extends State<MatchAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Match",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Consumer<MatchProvider>(
        builder: (context, match, child)=>Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: match.matchno,
                decoration: InputDecoration(
                    hintText:
                  "Match No."
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: match.firstteam,
                decoration: InputDecoration(
                    hintText:
                    "First Team Name"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: match.secondteam,
                decoration: InputDecoration(
                    hintText:
                    "Second Team Name"
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                onPressed: (){
                  match.AddMatch();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MatchesScreen()));
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
