import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartlease_new/screens/NotificationsScreen.dart';
import 'package:smartlease_new/screens/add_property_screen.dart';
import 'package:smartlease_new/screens/property_detail.dart';
import 'profile_screen.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({super.key});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  final user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
            child: Text(
          "Please login first",
          style: TextStyle(color: Colors.black),
        )),
        backgroundColor: Colors.yellow,
      );
    }

    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: const Text(
          "Owner Home",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddEditPropertyScreen()));
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('properties')
            .where('ownerId', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.black),
            ));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final properties = snapshot.data!.docs;
          if (properties.isEmpty) {
            return const Center(
                child: Text(
              "No properties added yet",
              style: TextStyle(color: Colors.black),
            ));
          }
          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final data = properties[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(10),
                color: Colors.yellow[200],
                child: ListTile(
                  title: Text(
                    data['name'] ?? 'Unnamed Property',
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    "Price: ₹${data['price'] ?? 'N/A'}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PropertyDetailScreen(
                                propertyId: properties[index].id)));
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
