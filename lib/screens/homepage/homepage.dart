import 'package:capstone_web/providers/authentication/authProvider.dart';
import 'package:capstone_web/providers/organization/fetchOrganization.dart';
import 'package:capstone_web/screens/login/loginPage.dart';
import 'package:capstone_web/sidebar%20menu/game%20results/gameResults.dart';
import 'package:capstone_web/sidebar%20menu/organizations/allOrganizations.dart';
import 'package:capstone_web/sidebar%20menu/users/allUsers.dart';
import 'package:capstone_web/sidebar%20menu/organizations/pendingApproval.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user != null ? user.email : 'Not Logged In';
    // Get the initial letter of the user's email or name

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              'CebuArena',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(), // This will push the email and avatar to the right
            Text(
              userEmail!,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 10), // Space between email and avatar
            CircleAvatar(
              child: Text(user != null ? user.email![0].toUpperCase() : 'A'),
              backgroundColor: Colors.white, // Background color of circle
              foregroundColor: Colors.black, // Text color
            ),
            SizedBox(width: 10), // Add some spacing
            // Logout button
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                // Logout user
                await FirebaseAuth.instance.signOut();
                // Navigate back to login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.black, // Dark AppBar for contrast
        elevation: 4.0, // Elevation for shadow
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor:
                Color(0xFF2A2D3E), // Dark background for NavigationRail
            selectedLabelTextStyle: TextStyle(
              color: Colors.cyan, // Vibrant color for selected item
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelTextStyle: TextStyle(color: Colors.grey),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.business, color: Colors.grey),
                selectedIcon: Icon(Icons.business, color: Colors.cyan),
                label: Text('Requests'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people, color: Colors.grey),
                selectedIcon: Icon(Icons.corporate_fare, color: Colors.cyan),
                label: Text('Organizations'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people, color: Colors.grey),
                selectedIcon: Icon(Icons.people, color: Colors.cyan),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.gamepad, color: Colors.grey),
                selectedIcon: Icon(Icons.logout, color: Colors.red),
                label: Text('Game Results'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.logout, color: Colors.grey),
                selectedIcon: Icon(Icons.logout, color: Colors.red),
                label: Text('Logout'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Expanded view for content
          Expanded(
            child: Consumer(
              builder: (context, ref, _) => _buildContent(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    // Retrieve the current user details from the provider
    final userDetails = ref.read(userDetailsProvider);

    // Check if the user is an admin
    final bool isAdmin = userDetails.isAdmin;

    // Content based on the selected index
    switch (_selectedIndex) {
      case 0:
        return isAdmin
            ? PendingApprovalsWidget()
            : SizedBox(); // Show PendingApprovalsWidget only for admins
      case 1:
        return OrganizationListPage();
      case 2:
        return isAdmin
            ? const AllUsersPage()
            : SizedBox(); // Show AllUsersPage only for admins
      case 3:
        return const GameResultsPage();
      case 4:
        // Handle logout case
        return ElevatedButton(
          onPressed: () async {
            // Logout user
            await FirebaseAuth.instance.signOut();
            // Navigate back to login page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text('Logout'),
        );
      default:
        return Center(child: Text('Content for $_selectedIndex'));
    }
  }
}
