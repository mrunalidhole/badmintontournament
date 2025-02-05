import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgressProvider extends ChangeNotifier{
  TextEditingController teamname = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController playername = TextEditingController();
  TextEditingController score = TextEditingController();

  Future<bool> AddProgress()async{
    try {
      final response = await Supabase.instance.client.from('addprogress')
          .insert({
        'teamname': teamname.text,
        'country': country.text,
        'playername': playername.text,
        'score': score.text
      });


      // Clear input fields after adding
      teamname.clear();
      country.clear();
      playername.clear();
      score.clear();
      notifyListeners();
    }catch (error) {
      debugPrint("Error adding team: $error");
    }
    return true;
  }
}