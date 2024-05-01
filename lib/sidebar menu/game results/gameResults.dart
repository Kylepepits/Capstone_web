import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_web/providers/getGameResults/gameResults.dart';
import 'package:url_launcher/url_launcher.dart';

class GameResultsPage extends ConsumerWidget {
  const GameResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Map<String, dynamic>>> gameResultsState =
        ref.watch(gameResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Results'),
      ),
      body: gameResultsState.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (gameResults) {
          if (gameResults.isEmpty) {
            return Center(child: Text('No game results to display'));
          } else {
            return ListView.builder(
              itemCount: gameResults.length,
              itemBuilder: (context, index) {
                var gameResult = gameResults[index];
                return GameResultCard(gameResult);
              },
            );
          }
        },
      ),
    );
  }
}

class GameResultCard extends StatelessWidget {
  final Map<String, dynamic> gameResult;

  GameResultCard(this.gameResult);

  @override
  Widget build(BuildContext context) {
    // Extract game results from the first element of the event list
    final Map<String, dynamic> gameResults =
        gameResult['game_results'].values.first;

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Name: ${gameResult['event_name'] ?? 'No Event Name'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Team Name: ${gameResults['team_name'] ?? 'No Team Name'}'),
            SizedBox(height: 8),
            Text('Wins: ${gameResults['win'] ?? '0'}'),
            SizedBox(height: 8),
            Text('Losses: ${gameResults['lose'] ?? '0'}'),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Open URL when button is pressed
                // ignore: deprecated_member_use
                launch(gameResults['gameProof_firebase_url']);
              },
              child: Text('View Proof'),
            ),
          ],
        ),
      ),
    );
  }
}
