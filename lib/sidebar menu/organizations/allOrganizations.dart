import 'package:capstone_web/providers/organization/fetchOrganization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Replace with the actual file name where your providers are defined

class OrganizationListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizations = ref.watch(organizationProvider);

    // Filter out organizations with no name, no description, and no owner
    final filteredOrganizations = organizations.where((org) =>
        org['org_name'] != null &&
        org['org_description'] != null &&
        org['owner'] != null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Organizations'),
      ),
      body: filteredOrganizations.isEmpty
          ? Center(child: Text('No organizations to display'))
          : ListView.builder(
              itemCount: filteredOrganizations.length,
              itemBuilder: (context, index) {
                var org = filteredOrganizations.elementAt(index);

                return OrganizationCard(org); // Use the OrganizationCard widget
              },
            ),
    );
  }
}

class OrganizationCard extends StatelessWidget {
  final Map<String, dynamic> organization;

  OrganizationCard(this.organization);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.blue, // Blue color for the check icon
                ),
                SizedBox(width: 8),
                Text(
                  'Organization Name: ${organization['org_name'] ?? 'No Name'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Blue color for the organization name
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
                'Description: ${organization['org_description'] ?? 'No Description'}'),
            SizedBox(height: 8),
            Text(
              'Owner: ${organization['owner']['firstname']} ${organization['owner']['lastname']}',
            ),
            SizedBox(height: 8),
            Text(
                'Username: ${organization['owner']['username'] ?? 'No Username'}'),
          ],
        ),
      ),
    );
  }
}
