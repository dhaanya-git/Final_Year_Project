import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  Map<String, dynamic>? property;

  @override
  void initState() {
    super.initState();
    _loadProperty();
  }

  void _loadProperty() async {
    final doc =
        await firestore.collection('properties').doc(widget.propertyId).get();
    if (doc.exists) {
      setState(() {
        property = doc.data();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (property == null) {
      return const Scaffold(
        body: Center(child: Text("Property not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(property!['name'] ?? 'Property Detail')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if ((property!['imageUrl'] ?? '').isNotEmpty)
              Image.network(property!['imageUrl'], height: 200),
            const SizedBox(height: 20),
            Text("Name: ${property!['name'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Price: ₹${property!['price'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Owner ID: ${property!['ownerId'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // For demo, you can open Google Maps or placeholder
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Open map feature for demo")));
              },
              child: const Text("View Location"),
            ),
          ],
        ),
      ),
    );
  }
}
