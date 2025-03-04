import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTeamProvider extends ChangeNotifier{
  TextEditingController teamname = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController playername = TextEditingController();

  Future<bool> AddTeam() async{
    try {
      final response = await Supabase.instance.client.from('addteam').insert({
        'teamname': teamname.text,
        'country': country.text,
        'playername': playername.text,
      });


      // Clear input fields after adding
      teamname.clear();
      country.clear();
      playername.clear();
      notifyListeners();
    }catch (error) {
      debugPrint("Error adding team: $error");
    }
    return true;
  }



}