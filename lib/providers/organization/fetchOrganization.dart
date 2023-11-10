import 'dart:convert';
import 'package:capstone_web/models/models.dart';
import 'package:capstone_web/providers/authentication/authProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
// Import your UserDetailsProvider

final pendingApprovalProvider =
    StateNotifierProvider<PendingApprovalNotifier, List<Map<String, dynamic>>>(
        (ref) {
  return PendingApprovalNotifier(ref
      .watch(userDetailsProvider)); // Assuming you have a userDetailsProvider
});

class PendingApprovalNotifier
    extends StateNotifier<List<Map<String, dynamic>>> {
  final UserDetailsProvider userDetails;

  PendingApprovalNotifier(this.userDetails) : super([]) {
    fetchPendingApprovals();
  }

  Future<void> fetchPendingApprovals() async {
    try {
      final localId = userDetails.localId;

      if (localId == null) {
        print('No user logged in');
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        return;
      }

      final token = await user.getIdToken();
      print('Token: $token');

      String url = 'http://127.0.0.1:8000/get_pending_approvals/$localId/';

      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic> &&
            data.containsKey('pending_approvals')) {
          // Extract the "pending_approvals" array from the response
          List<dynamic> pendingApprovals = data['pending_approvals'];

          // Convert each item in the list to a Map<String, dynamic>
          // Inside your fetchPendingApprovals method
          List<Map<String, dynamic>> formattedApprovals =
              pendingApprovals.map<Map<String, dynamic>>((item) {
            return {
              'is_approved': item['is_approved'],
              'org_description': item['org_description'],
              'org_name': item['org_name'],
              'org_id': item['org_id'], // Add 'org_id' to the data
              'owner': {
                'firstname': item['owner']['firstname'],
                'lastname': item['owner']['lastname'],
                'localId': item['owner']['localId'],
                'username': item['owner']['username'],
              }
            };
          }).toList();

          print(formattedApprovals); // Print formatted pending approvals
          state = formattedApprovals;
        } else {
          print('Invalid response data format: $data');
        }
      } else {
        print('Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      print('Network request failed: $e');
    }
  }
}

final approveOrganizationProvider =
    Provider.autoDispose<void Function(String, String)>((ref) {
  final userDetails = ref.watch(userDetailsProvider);
  final user = FirebaseAuth.instance.currentUser!;

  return (String localId, String orgId) async {
    try {
      // You may need to adjust this URL based on your server's endpoint
      const url = 'http://127.0.0.1:8000/approve_organization/';

      final token = await user.getIdToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'localId': localId, 'org_id': orgId}),
      );

      if (response.statusCode == 200) {
        // Organization approval was successful
        // You can handle success actions here if needed
      } else if (response.statusCode == 403) {
        // Handle the case where the user does not have admin privileges
      } else {
        // Handle other error cases
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network request or other errors
      print('Error: $e');
    }
  };
});

final organizationProvider =
    StateNotifierProvider<OrganizationNotifier, List<Map<String, dynamic>>>(
        (ref) {
  return OrganizationNotifier(ref.watch(userDetailsProvider));
});

class OrganizationNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final UserDetailsProvider userDetails;

  OrganizationNotifier(this.userDetails) : super([]) {
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user logged in');
        return;
      }

      final token = await user.getIdToken();
      const url = 'http://127.0.0.1:8000/all_organizations/';

      var response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;

        List<Map<String, dynamic>> organizations =
            data.map<Map<String, dynamic>>((item) {
          return Map<String, dynamic>.from(item);
        }).toList();

        state = organizations;
      } else {
        print('Server returned status code ${response.statusCode}');
      }
    } catch (e) {
      print('Network request failed: $e');
    }
  }
}
