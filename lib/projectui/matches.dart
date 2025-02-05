import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badmintontournament/provider/drawprovider.dart';
import '../provider/matchprovider.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MatchProvider(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "Matches",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Round 1"),
                Tab(text: "Semifinal"),
                Tab(text: "Final"),
              ],
            ),
          ),
          body: Consumer2<DrawProvider, MatchProvider>(
            builder: (context, draw, matchProvider, child) {
              if (draw.matches.isEmpty) {
                return const Center(child: Text('Matches not Available'));
              }

              List<List<Map<String, dynamic>>> round1Matches = draw.matches;
              List<List<Map<String, dynamic>>> semifinalMatches = _getWinners(round1Matches, matchProvider.matchScores);
              List<List<Map<String, dynamic>>> finalMatches = _getWinners(semifinalMatches, matchProvider.semifinalScores);

              return TabBarView(
                children: [
                  _buildMatchList(context, matchProvider, round1Matches, "Round 1"),
                  _buildMatchList(context, matchProvider, semifinalMatches, "Semifinal", isSemifinal: true),
                  _buildMatchList(context, matchProvider, finalMatches, "Final", isFinal: true),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Function to determine winners and advance them to the next round
  List<List<Map<String, dynamic>>> _getWinners(List<List<Map<String, dynamic>>> matches, Map<int, List<int>> scores) {
    List<List<Map<String, dynamic>>> nextRoundMatches = [];

    for (int i = 0; i < matches.length; i += 2) {
      if (i + 1 >= matches.length) break; // Ensure there are enough teams to pair

      int match1Score1 = scores[i]?[0] ?? 0;
      int match1Score2 = scores[i]?[1] ?? 0;
      int match2Score1 = scores[i + 1]?[0] ?? 0;
      int match2Score2 = scores[i + 1]?[1] ?? 0;

      // Determine winners of each match
      Map<String, dynamic> winner1 = match1Score1 >= match1Score2 ? matches[i][0] : matches[i][1];
      Map<String, dynamic> winner2 = match2Score1 >= match2Score2 ? matches[i + 1][0] : matches[i + 1][1];

      // Add winners to next round
      nextRoundMatches.add([winner1, winner2]);
    }

    return nextRoundMatches;
  }

  Widget _buildMatchList(BuildContext context, MatchProvider matchProvider, List<List<Map<String, dynamic>>> matches, String roundName, {bool isSemifinal = false, bool isFinal = false}) {
    return matches.isEmpty
        ? Center(child: Text(
        "$roundName Matches Not Available"
    )
    )
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, i) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.32,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Column(
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: Colors.grey.shade400),
                        child: Center(
                          child: Text(
                            "Match ${i + 1} - $roundName",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTeamScoreSection(context, matchProvider, matches[i][0], i, 0, isSemifinal: isSemifinal, isFinal: isFinal),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "🆚",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          _buildTeamScoreSection(context, matchProvider, matches[i][1], i, 1, isSemifinal: isSemifinal, isFinal: isFinal),
                        ],
                      ),
                      if (!(isFinal ? matchProvider.completedFinalMatches : (isSemifinal ? matchProvider.completedSemifinalMatches : matchProvider.completedMatches)).contains(i))
                        ElevatedButton(
                          onPressed: () => matchProvider.completeMatch(i, isSemifinal: isSemifinal, isFinal: isFinal),
                          child: const Text("Complete Match"),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamScoreSection(BuildContext context, MatchProvider matchProvider, Map<String, dynamic> team, int matchIndex, int teamIndex, {bool isSemifinal = false, bool isFinal = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(team['teamname'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(team['country'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text("Player: ${team['playername']}", style: const TextStyle(fontSize: 14)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => matchProvider.updateScore(matchIndex, teamIndex, -1, isSemifinal: isSemifinal, isFinal: isFinal),
              ),
              Text(
                "${(isFinal ? matchProvider.finalScores : (isSemifinal ? matchProvider.semifinalScores : matchProvider.matchScores))[matchIndex]?[teamIndex] ?? 0}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => matchProvider.updateScore(matchIndex, teamIndex, 1, isSemifinal: isSemifinal, isFinal: isFinal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
