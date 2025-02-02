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
    // TODO: implement initState
    super.initState();
    FetchMatch();
  }

  FetchMatch() async{
    final response = await Supabase.instance.client.from('addmatch').select();
    setState(() {
      match = List<Map<String, dynamic>>.from(response);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MatchAdd()));
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
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: match.length,
          itemBuilder: (BuildContext context, int i){
        return SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Container(
                  height: 160,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade400
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 1,),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: (){},
                              icon: Icon(
                                  Icons.delete_outline
                              )
                          ),
                        ],
                      ),
                      Container(
                        height: 25,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                          color: Colors.black
                        ),
                        child: Center(
                          child: Text(
                            "Match",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.black45,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              match[i]['teamname'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              match[i]['teamname2'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      })
    );
  }
}
