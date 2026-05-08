import 'package:flutter/material.dart';
import 'firestore_service.dart';

class LeasePage extends StatefulWidget {
  final Map<String, dynamic> land;
  final String token;

  const LeasePage({super.key, required this.land, required this.token});

  @override
  State<LeasePage> createState() => _LeasePageState();
}

class _LeasePageState extends State<LeasePage> {
  final firestore = FirestoreService();
  bool loading = false;

  void requestLease() async {
    setState(() => loading = true);
    await firestore.addDocument(
      "lease_requests",
      {
        "land_name": widget.land['name'],
        "location": widget.land['location'],
        "status": "pending"
      },
      widget.token,
    );
    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lease requested!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Lease Land"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Land: ${widget.land['name']}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Location: ${widget.land['location']}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              "Size: ${widget.land['size']}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Center(
              child: loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: requestLease,
                        child: const Text(
                          "Request Lease",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
