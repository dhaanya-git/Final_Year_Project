import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class LandListScreen extends StatelessWidget {
  const LandListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final lands = appState.lands;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Available Land'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: lands.length,
        itemBuilder: (context, i) {
          final l = lands[i];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                l.title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                '${l.location} • ₹${l.pricePerMonth}/mo',
                style: TextStyle(color: Colors.grey[700]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.pushNamed(
                context,
                '/landDetail',
                arguments: {'landId': l.id},
              ),
            ),
          );
        },
      ),
    );
  }
}
