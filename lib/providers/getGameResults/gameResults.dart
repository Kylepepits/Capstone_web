import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final gameResultsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/get_game_results/'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> responseData =
        json.decode(response.body)['events_with_game_results'];

    // Cast each item in the list to Map<String, dynamic>
    final List<Map<String, dynamic>> gameResults = responseData.map((item) {
      if (item is Map<String, dynamic>) {
        return item;
      } else {
        throw Exception('Invalid data format');
      }
    }).toList();

    return gameResults;
  } else {
    throw Exception('Failed to load game results');
  }
});
