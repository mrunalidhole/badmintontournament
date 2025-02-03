import 'package:badmintontournament/projectui/draw.dart';
import 'package:badmintontournament/projectui/matches.dart';
import 'package:badmintontournament/projectui/progress.dart';
import 'package:badmintontournament/projectui/team.dart';
import 'package:badmintontournament/projectui/tournament.dart';
import 'package:badmintontournament/provider/matchprovider.dart';
import 'package:badmintontournament/provider/teamprovider.dart';
import 'package:badmintontournament/provider/tournamentprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  await Supabase.initialize(url: 'https://fockzwwzgvmxwlheozqn.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZvY2t6d3d6Z3ZteHdsaGVvenFuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg0NzQ1MjYsImV4cCI6MjA1NDA1MDUyNn0.6qoTOSv3ZTi8SgTc4gkO2No22MNtywqj-jdeBIubblk');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context)=>AddTeamProvider()),
      ChangeNotifierProvider(create: (context)=>TournamentProvider()),
      ChangeNotifierProvider(create: (context)=>MatchProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;
  List pages = [
    TeamScreen(),
    TournamentScreen(),
    DrawScreen(),
    MatchesScreen(),
    ProgressScreen()
  ];

  void onTap(int ind){
    setState(() {
      index = ind;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: Consumer<AddTeamProvider>(
        builder: (context, mainpage, child)=>BottomNavigationBar(
          currentIndex: index,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          unselectedLabelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.group,
                  size: 30,
                  color: Colors.black,
                ),
                label: "Team"
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.emoji_events,
                  size: 30,
                  color: Colors.black,
                ),
                label: "Tournament"
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.grid_view,
                  size: 30,
                  color: Colors.black,
                ),
                label: "Draw"
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.sports_tennis,
                  size: 30,
                  color: Colors.black,
                ),
                label: "Matches"
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.military_tech,
                size: 30,
                color: Colors.black,
              ),
              label: "Progress",
            )
          ],
        ),
      ),
    );
  }
}
