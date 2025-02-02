import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentProvider extends ChangeNotifier{
  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController date = TextEditingController();

  Future<bool> AddTournament()async{
    final response = await Supabase.instance.client.from('addtournament').insert({
      'title': title.text,
      'location': location.text,
      'date': date.text
    });
    return true;
  }
}