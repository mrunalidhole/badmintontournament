import 'package:badmintontournament/projectui/tournament.dart';
import 'package:badmintontournament/provider/tournamentprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TournamentForm extends StatefulWidget {
  const TournamentForm({super.key});

  @override
  State<TournamentForm> createState() => _TeamFormState();
}

class _TeamFormState extends State<TournamentForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Tournament",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Consumer<TournamentProvider>(
        builder: (context, tournament, child)=>Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: tournament.title,
                decoration: InputDecoration(
                    hintText: "Title"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: tournament.location,
                decoration: InputDecoration(
                    hintText: "Location"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: tournament.date,
                decoration: InputDecoration(
                    hintText: "Date"
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
                onPressed: (){
                  tournament.AddTournament();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TournamentScreen()));
                },
                child: Text(
                  "Create",
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
