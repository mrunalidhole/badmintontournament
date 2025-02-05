import 'package:badmintontournament/projectui/tournamentform.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  List<Map<String, dynamic>> tournament = [];

  @override
  void initState() {
    super.initState();
    FetchTournament();
  }

  FetchTournament() async {
    final response = await Supabase.instance.client.from('addtournament').select();
    setState(() {
      tournament = List<Map<String, dynamic>>.from(response);
    });
  }

  // Delete tournament from Supabase and update UI
  deleteTournament(int index) async {
    String tournamentId = tournament[index]["id"].toString();

    try {
      // Delete from Supabase first
      await Supabase.instance.client.from('addtournament').delete().eq('id', tournamentId);

      // Update UI only after successful deletion
      setState(() {
        tournament.removeAt(index);
      });
    } catch (error) {
      debugPrint("Error deleting team: $error");

      // Show error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting tournament")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (context) => TournamentForm()));
            FetchTournament();
          },
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Tournaments",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView.builder(
              itemCount: tournament.length,
              itemBuilder: (BuildContext context, int i) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      tournament[i]["title"],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: IconButton(
                                      onPressed: () {
                                        deleteTournament(i); // Call delete function
                                      },
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(tournament[i]["date"]),
                                  ),
                                  SizedBox(width: 10),
                                  Text(tournament[i]["location"]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
        )
    );
  }
}
