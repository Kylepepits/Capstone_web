import 'package:capstone_web/providers/authentication/authProvider.dart';
import 'package:capstone_web/providers/organization/fetchOrganization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingApprovalsWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingApprovals = ref.watch(pendingApprovalProvider);

    // Check if the list is empty or null
    if (pendingApprovals.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Pending Approvals'),
        ),
        body: Center(child: Text('No pending approvals.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Approvals'),
      ),
      body: ListView.builder(
        itemCount: pendingApprovals.length,
        itemBuilder: (context, index) {
          final approval = pendingApprovals[index];

          return _buildApprovalCard(context, ref, approval);
        },
      ),
    );
  }

  Widget _buildApprovalCard(
      BuildContext context, WidgetRef ref, Map<String, dynamic> approval) {
    final bool isApproved = approval['is_approved'];
    final String orgId = approval['org_id'];

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
                  isApproved ? Icons.check_circle : Icons.cancel,
                  color: isApproved ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Organization Name: ${approval['org_name']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Description: ${approval['org_description']}'),
            SizedBox(height: 8),
            Text(
                'Owner: ${approval['owner']['firstname']} ${approval['owner']['lastname']}'),
            SizedBox(height: 8),
            Text('Username: ${approval['owner']['username']}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle approval action here using orgId
                _approveOrganization(context, ref, orgId);
              },
              child: Text('Approve'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _approveOrganization(
    BuildContext context,
    WidgetRef ref,
    String orgId,
  ) async {
    try {
      final userDetails = ref.watch(userDetailsProvider);
      final approveFunction = ref.read(approveOrganizationProvider);
      final localId = userDetails.localId;

      if (localId != null) {
        // Call the approveOrganizationProvider to approve the organization
        approveFunction(localId, orgId);

        // Optionally, you can refresh the pending approvals list here if needed
      } else {
        // Handle the case where there is no user logged in
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No user logged in.'),
        ));
      }
    } catch (e) {
      // Handle errors if any
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));

      // Print the error for debugging purposes
      print('Error in _approveOrganization: $e');
    }
  }
}
