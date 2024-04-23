import 'package:capstone_web/providers/organization/fetchOrganization.dart';
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
                label: Text('Organizations'),
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
                icon: Icon(Icons.logout, color: Colors.grey),
                selectedIcon: Icon(Icons.logout, color: Colors.red),
                label: Text('Logout'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Expanded view for content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Content based on the selected index
    switch (_selectedIndex) {
      case 0:
        return PendingApprovalsWidget();
      case 1:
        return OrganizationListPage();
      case 2:
        return AllUsersPage();
      case 3:
        return Center(child: Text('Logging out...'));
      default:
        return Center(child: Text('Content for $_selectedIndex'));
    }
  }
}
