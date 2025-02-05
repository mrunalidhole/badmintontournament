import 'package:badmintontournament/projectui/team.dart';
import 'package:badmintontournament/provider/teamprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamForm extends StatefulWidget {
  const TeamForm({super.key});

  @override
  State<TeamForm> createState() => _TeamFormState();
}

class _TeamFormState extends State<TeamForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Team",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
       body: Consumer<AddTeamProvider>(
         builder: (context, team, child)=>Column(
           children: [
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: TextField(
                 controller: team.teamname,
                 decoration: InputDecoration(
                     hintText: "Team Name"
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: TextField(
                 controller: team.country,
                 decoration: InputDecoration(
                     hintText: "Country"
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: TextField(
                 controller: team.playername,
                 decoration: InputDecoration(
                     hintText: "Player Name"
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
                   await team.AddTeam();
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TeamScreen()));
                   },
                   child: Text(
                     "Add Team",
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
