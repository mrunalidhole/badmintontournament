import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentProvider extends ChangeNotifier{
  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController date = TextEditingController();

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  void setDate(DateTime date){
    _selectedDate = date;
    notifyListeners();
  }

  Future<bool> AddTournament()async{
    try {
      final response = await Supabase.instance.client.from('addtournament')
          .insert({
        'title': title.text,
        'location': location.text,
        'date': date.text
      });


      // Clear input fields after adding
      title.clear();
      location.clear();
      date.clear();
      notifyListeners();
    }catch (error) {
      debugPrint("Error adding team: $error");
    }
    return true;
  }
}