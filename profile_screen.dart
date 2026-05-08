import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_screen.dart'; // Make sure this exists

class ProfileScreen extends StatefulWidget {
  final String? userId; // optional to view other profiles
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String phone = '';
  String profileImageUrl = '';
  File? profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final uid = widget.userId ?? user?.uid;
    if (uid == null) return;
    final doc = await firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      phone = data['phone'] ?? '';
      profileImageUrl = data['profileImage'] ?? '';
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => profileImage = File(picked.path));
    }
  }

  Future<String?> _uploadImage() async {
    if (profileImage == null) return null;
    final ref = FirebaseStorage.instance.ref().child(
        'profile_images/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(profileImage!);
    return await ref.getDownloadURL();
  }

  void _saveProfile() async {
    if (user == null) return;
    setState(() => isLoading = true);

    final imageUrl = await _uploadImage();

    final data = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      if (imageUrl != null) 'profileImage': imageUrl,
    };

    await firestore
        .collection('users')
        .doc(user!.uid)
        .set(data, SetOptions(merge: true));

    setState(() => isLoading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Profile updated")));
  }

  void _launchEmail(String email) async {
    final url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchPhone(String phone) async {
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null && widget.userId == null) {
      return const Scaffold(
        body: Center(
            child: Text("Please login first",
                style: TextStyle(color: Colors.black))),
        backgroundColor: Colors.yellow,
      );
    }

    bool isOwnProfile = widget.userId == null || widget.userId == user!.uid;

    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : (profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl) as ImageProvider
                              : null),
                      child: profileImage == null && profileImageUrl.isEmpty
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.white)
                          : null,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    if (isOwnProfile)
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent),
                        child: const Text("Pick Profile Image",
                            style: TextStyle(color: Colors.white)),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      enabled: isOwnProfile,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.yellow[200],
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      enabled: isOwnProfile,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.yellow[200],
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap:
                          phone.isNotEmpty ? () => _launchPhone(phone) : null,
                      child: Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            phone.isNotEmpty ? phone : 'Phone not provided',
                            style: TextStyle(
                              color: phone.isNotEmpty
                                  ? Colors.blue
                                  : Colors.black54,
                              decoration: phone.isNotEmpty
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: emailController.text.isNotEmpty
                          ? () => _launchEmail(emailController.text)
                          : null,
                      child: Row(
                        children: [
                          const Icon(Icons.email, color: Colors.black),
                          const SizedBox(width: 10),
                          Text(
                            emailController.text.isNotEmpty
                                ? emailController.text
                                : 'Email not provided',
                            style: TextStyle(
                              color: emailController.text.isNotEmpty
                                  ? Colors.blue
                                  : Colors.black54,
                              decoration: emailController.text.isNotEmpty
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (isOwnProfile)
                      ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent),
                        child: const Text("Save Profile",
                            style: TextStyle(color: Colors.white)),
                      ),
                    // ---- Logout Button Added ----
                    if (isOwnProfile) ...[
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
