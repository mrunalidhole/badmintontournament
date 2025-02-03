import 'package:badmintontournament/projectui/matchadd.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<Map<String, dynamic>> match = [];

  @override
  void initState() {
    super.initState();
    FetchMatch();
  }

  // Fetch matches from Supabase
  FetchMatch() async {
    final response = await Supabase.instance.client.from('addmatch').select();
    setState(() {
      match = List<Map<String, dynamic>>.from(response);
    });
  }

  // Delete match from Supabase and update local list
  deleteMatch(int index) async {
    String matchId = match[index]["id"].toString(); // Ensure the ID exists

    // Deleting the match from Supabase
    final response = await Supabase.instance.client.from('addmatch').delete().eq('id', matchId);

    // Check if the deletion was successful
    if (response.error == null) {
      setState(() {
        match.removeAt(index); // Remove from local list and update UI
      });
    } else {
      // Handle error if any (you can show a Snackbar or Toast here)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting match")),
      );
    }
  }

  void updateScore(int index, String team, bool isIncrement) {
    setState(() {
      if (team == "first") {
        match[index]["score1"] =
        isIncrement ? match[index]["score1"] + 1 : (match[index]["score1"] > 0 ? match[index]["score1"] - 1 : 0);
      } else {
        match[index]["score2"] =
        isIncrement ? match[index]["score2"] + 1 : (match[index]["score2"] > 0 ? match[index]["score2"] - 1 : 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MatchAdd()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Matches",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView.builder(
            itemCount: match.length,
            itemBuilder: (BuildContext context, int i) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(color: Colors.grey.shade400),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      "Match No: ${match[i]["matchno"]}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text("${match[i]["location"]}"),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: IconButton(
                                        onPressed: () {
                                          deleteMatch(i); // Call delete function
                                        },
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("${match[i]["date"]}"),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // First Team with Score Displayed Twice
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        match[i]["firstteam"],
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),

                                      // Score in Middle
                                      Text(
                                        match[i]["score1"].toString(),
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),

                                      // Score Control Buttons
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                            onPressed: () => updateScore(i, "first", false),
                                          ),
                                          Text(
                                            match[i]["score1"].toString(),
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                            onPressed: () => updateScore(i, "first", true),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),

                                  // Second Team with Score Displayed Twice
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        match[i]["secondteam"],
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),

                                      // Score in Middle
                                      Text(
                                        match[i]["score2"].toString(),
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),

                                      // Score Control Buttons
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                            onPressed: () => updateScore(i, "second", false),
                                          ),
                                          Text(
                                            match[i]["score2"].toString(),
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                            onPressed: () => updateScore(i, "second", true),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
