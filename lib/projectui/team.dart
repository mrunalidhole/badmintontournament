import 'package:badmintontournament/projectui/teamform.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:country_flags/country_flags.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TeamScreen(),
    );
  }
}

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  List<Map<String, dynamic>> team = [];

  @override
  void initState() {
    super.initState();
    FetchTeam();
  }

  // Fetch teams from Supabase
  FetchTeam() async {
    final response = await Supabase.instance.client.from('addteam').select();
    setState(() {
      team = List<Map<String, dynamic>>.from(response);
    });
  }

  // Delete team from Supabase and update the local list
  deleteTeam(int index) async {
    String teamId = team[index]["id"].toString(); // Ensure the ID exists

    // Deleting the team from Supabase
    final response = await Supabase.instance.client.from('addteam').delete().eq('id', teamId);

    // Check if the deletion was successful
    if (response.error == null) {
      setState(() {
        team.removeAt(index); // Remove from local list and update UI
      });
    } else {
      // Handle error if any (you can show a Snackbar or Toast here)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting team")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TeamForm()));
          },
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Teams",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView.builder(
              itemCount: team.length,
              itemBuilder: (BuildContext context, int i) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.16,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(color: Colors.grey.shade400),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        team[i]["teamname"],
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: IconButton(
                                        onPressed: () {
                                          deleteTeam(i); // Call delete function
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "Player Name: ${team[i]["playername"]}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
