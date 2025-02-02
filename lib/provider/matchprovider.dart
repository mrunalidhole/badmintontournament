import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchProvider extends ChangeNotifier{
  TextEditingController matchno = TextEditingController();
  TextEditingController firstteam = TextEditingController();
  TextEditingController secondteam = TextEditingController();
  
  Future<bool>AddMatch() async{
    final response = await Supabase.instance.client.from('addmatch').insert({
      'matchno': matchno.text,
      'firstteam': firstteam.text,
      'secondteam': secondteam.text
    });
    return true;
  }
}