import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchProvider extends ChangeNotifier {
  Map<int, List<int>> matchScores = {};
  Set<int> completedMatches = {};
  Set<int> completedSemifinalMatches = {};
  Map<int, List<int>> semifinalScores = {};
  Map<int, List<int>> finalScores = {};
  Set<int> completedFinalMatches = {};

  final supabase = Supabase.instance.client;

  void updateScore(int matchIndex, int teamIndex, int change, {bool isSemifinal = false, bool isFinal = false}) {
    if (isFinal && completedFinalMatches.contains(matchIndex)) return;
    if (isSemifinal && completedSemifinalMatches.contains(matchIndex)) return;
    if (!isSemifinal && !isFinal && completedMatches.contains(matchIndex)) return;

    var scores = isFinal ? finalScores : (isSemifinal ? semifinalScores : matchScores);
    scores.putIfAbsent(matchIndex, () => [0, 0]);
    scores[matchIndex]![teamIndex] += change;
    if (scores[matchIndex]![teamIndex] < 0) {
      scores[matchIndex]![teamIndex] = 0;
    }

    notifyListeners();
  }


  Future<void> completeMatch(int matchIndex, {bool isSemifinal = false, bool isFinal = false}) async {
    if (isFinal) {
      completedFinalMatches.add(matchIndex);
    } else if (isSemifinal) {
      completedSemifinalMatches.add(matchIndex);
    } else {
      completedMatches.add(matchIndex);
    }

    notifyListeners();


  }
}
