import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:capstone_web/providers/getUsers/fetchAllUsers.dart'
    as getUsersProvider; // import with alias

class AllUsersPage extends ConsumerWidget {
  const AllUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<dynamic>> usersState =
        ref.watch(getUsersProvider.getAllUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
      ),
      body: usersState.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (users) {
          if (users.isEmpty) {
            return Center(child: Text('No users to display'));
          } else {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return UserCard(user);
              },
            );
          }
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  UserCard(this.user);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${user['username'] ?? 'No Username'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Email: ${user['email'] ?? 'No Email'}'),
            SizedBox(height: 8),
            Text('First Name: ${user['firstname'] ?? 'No First Name'}'),
            SizedBox(height: 8),
            Text('Last Name: ${user['lastname'] ?? 'No Last Name'}'),
          ],
        ),
      ),
    );
  }
}
