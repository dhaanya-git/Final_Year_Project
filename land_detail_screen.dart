import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
// ignore: unused_import
import '../models/land.dart';

class LandDetailScreen extends StatefulWidget {
  final String landId;
  const LandDetailScreen({super.key, required this.landId});

  @override
  _LandDetailScreenState createState() => _LandDetailScreenState();
}

class _LandDetailScreenState extends State<LandDetailScreen> {
  final monthsCtrl = TextEditingController(text: '6');

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final land = appState.lands.firstWhere((l) => l.id == widget.landId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(land.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              land.location,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${land.areaAcres} acres • ₹${land.pricePerMonth}/mo',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              land.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: monthsCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Months',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final farmerId = appState.users.isNotEmpty
                      ? appState.users.first.id
                      : 'farmer_demo';
                  await appState.requestLease(
                    landId: land.id,
                    farmerId: farmerId,
                    months: int.tryParse(monthsCtrl.text) ?? 1,
                    monthlyPrice: land.pricePerMonth,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lease request sent')),
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Request Lease',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
