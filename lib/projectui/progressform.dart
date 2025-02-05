import 'package:badmintontournament/projectui/progress.dart';
import 'package:badmintontournament/projectui/tournament.dart';
import 'package:badmintontournament/provider/progressprovider.dart';
import 'package:badmintontournament/provider/tournamentprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProgressForm extends StatefulWidget {
  const ProgressForm({super.key});

  @override
  State<ProgressForm> createState() => _TeamFormState();
}

class _TeamFormState extends State<ProgressForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Progress",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progress, child)=>Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: progress.teamname,
                decoration: InputDecoration(
                    hintText: "Team Name"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: progress.country,
                decoration: InputDecoration(
                    hintText: "Country"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: progress.playername,
                decoration: InputDecoration(
                    hintText: "PlayerName"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: progress.score,
                decoration: InputDecoration(
                    hintText: "Score"
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                onPressed: () async{
                  await progress.AddProgress();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProgressScreen()));
                },
                child: Text(
                  "Add",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
