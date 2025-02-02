import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTeamProvider extends ChangeNotifier{
  TextEditingController teamname = TextEditingController();
  TextEditingController playername = TextEditingController();

  Future<bool> AddTeam() async{
    final response = await Supabase.instance.client.from('addteam').insert({
      'teamname': teamname.text,
      'playername': playername.text
    });
    return true;
  }



}