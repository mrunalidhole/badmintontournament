import 'package:badmintontournament/projectui/teamform.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  deleteTeam(int index) async {
    String teamId = team[index]["id"].toString();

    try {
      // Delete from Supabase first
      await Supabase.instance.client.from('addteam').delete().eq('id', teamId);

      // Update UI only after successful deletion
      setState(() {
        team.removeAt(index);
      });
    } catch (error) {
      debugPrint("Error deleting team: $error");

      // Show error message if deletion fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting team")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          onPressed: () async{
            await Navigator.push(context, MaterialPageRoute(builder: (context) => TeamForm()));
            FetchTeam();
          },
          backgroundColor: Colors.black,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.18,
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
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade400
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(
                                        team[i]["teamname"],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: IconButton(
                                        onPressed: () {
                                          deleteTeam(i);
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      team[i]["country"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Text(
                                        "Player No.: ${i + 1}",
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    ),
                                    Text(
                                      "Player Name: ${team[i]["playername"]}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
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
        )
    );
  }
}
