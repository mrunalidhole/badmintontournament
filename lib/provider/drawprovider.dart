import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DrawProvider with ChangeNotifier {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> participants = [];
  List<List<Map<String, dynamic>>> matches = [];

  DrawProvider() {
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    try {
      final response = await supabase.from('addteam').select();
      if (response.isNotEmpty) {
        participants = List<Map<String, dynamic>>.from(response);
        generateDraw();
      }
    } catch (error) {
      debugPrint("Error fetching teams: $error");
    }
  }

  void generateDraw() {
    matches.clear();
    participants.shuffle(Random());

    for (int i = 0; i < participants.length; i += 2) {
      if (i + 1 < participants.length) {
        matches.add([participants[i], participants[i + 1]]);
      }
    }

    notifyListeners();
    saveMatchesToSupabase();
  }

  Future<void> saveMatchesToSupabase() async {
    try {
      if (matches.isEmpty) return;

      List<Map<String, dynamic>> matchEntries = matches.asMap().entries.map((entry) {
        int index = entry.key;
        List<Map<String, dynamic>> match = entry.value;
        return {
          'matchno': index + 1,
          'team1name': match[0]['teamname'],
          'team1country': match[0]['country'],
          'team1player': match[0]['player'],
          'team2name': match[1]['teamname'],
          'team2country': match[1]['country'],
          'team2player': match[1]['player'],
        };
      }).toList();

      await supabase.from('matchdraw').insert(matchEntries);
      debugPrint("Matches saved successfully!");
    } catch (error) {
      debugPrint("Error saving matches: $error");
    }
  }
}
