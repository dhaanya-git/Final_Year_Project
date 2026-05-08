import 'package:flutter/material.dart';
import 'firestore_service.dart';

class LeaseRequestsScreen extends StatefulWidget {
  final Map<String, dynamic> land;
  final String token;

  const LeaseRequestsScreen({
    super.key,
    required this.land,
    required this.token,
  });

  @override
  State<LeaseRequestsScreen> createState() => _LeaseRequestsScreenState();
}

class _LeaseRequestsScreenState extends State<LeaseRequestsScreen> {
  final firestore = FirestoreService();
  List<Map<String, dynamic>> requests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    final result = await firestore.getDocuments("lease_requests", widget.token);
    setState(() {
      requests =
          result.where((r) => r['land_name'] == widget.land['name']).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Lease Requests"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
              ? Center(
                  child: Text(
                    "No lease requests yet.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final r = requests[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          r['land_name'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        subtitle: Text(
                          "Status: ${r['status'] ?? ''}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        leading: Icon(Icons.request_page,
                            color: Theme.of(context).primaryColor),
                      ),
                    );
                  },
                ),
    );
  }
}
