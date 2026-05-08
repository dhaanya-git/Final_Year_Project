import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartlease_new/screens/NotificationsScreen.dart';
import 'package:smartlease_new/screens/property_detail.dart';
import 'profile_screen.dart';

class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Please login first",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        backgroundColor: Colors.yellow,
      );
    }

    return Scaffold(
      backgroundColor: Colors.yellow[700], // Yellow background
      appBar: AppBar(
        title: const Text(
          "Farmer Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.yellow[800], // Darker yellow for contrast
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('properties').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final properties = snapshot.data!.docs;

          if (properties.isEmpty) {
            return const Center(
              child: Text(
                "No properties available",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.yellow[600], // Slightly lighter yellow
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    property['name'] ?? 'No name',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Price: ₹${property['price'] ?? 'N/A'}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward, color: Colors.white),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PropertyDetailScreen(
                            propertyId: properties[index].id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
