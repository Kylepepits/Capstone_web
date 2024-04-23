import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final getAllUsersProvider = FutureProvider<List<dynamic>>((ref) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/all_users/'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> usersData = json.decode(response.body);
    return usersData;
  } else {
    throw Exception('Failed to load users');
  }
});
