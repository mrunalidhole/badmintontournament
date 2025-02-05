import 'package:badmintontournament/projectui/progressform.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {

  List<Map<String, dynamic>> progress = [];

  @override
  void initState() {
    super.initState();
    FetchProgress();
  }

  FetchProgress() async {
    final response = await Supabase.instance.client.from('addprogress').select();
    setState(() {
      progress = List<Map<String, dynamic>>.from(response);
    });
  }

  // Delete tournament from Supabase and update UI
  deleteTournament(int index) async {
    String tournamentId = progress[index]["id"].toString();

    try {
      // Delete from Supabase first
      await Supabase.instance.client.from('addtournament').delete().eq('id', tournamentId);

      // Update UI only after successful deletion
      setState(() {
        progress.removeAt(index);
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
          await Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressForm()));
          FetchProgress();
        },
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Progress",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView.builder(
              itemCount: progress.length,
              itemBuilder: (BuildContext context, int i) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.17,
                          width: MediaQuery.of(context).size.width * 0.9,
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
                                      progress[i]["teamname"],
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
                            ),
                              SizedBox(height: 8,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                    progress[i]["country"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                    "Player Name: ${progress[i]["playername"]}"
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  "Score: ${progress[i]["score"]}"
                                ),
                              )
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
