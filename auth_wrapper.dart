import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddEditPropertyScreen extends StatefulWidget {
  final String? propertyId; // null for add, non-null for edit
  const AddEditPropertyScreen({super.key, this.propertyId});

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  File? imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null) {
      _loadPropertyData();
    }
  }

  void _loadPropertyData() async {
    final doc =
        await firestore.collection('properties').doc(widget.propertyId).get();
    if (doc.exists) {
      final data = doc.data()!;
      nameController.text = data['name'] ?? '';
      priceController.text = data['price']?.toString() ?? '';
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  Future<String?> _uploadImage() async {
    if (imageFile == null) return null;
    final ref = FirebaseStorage.instance.ref().child(
        'property_images/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(imageFile!);
    return await ref.getDownloadURL();
  }

  void _saveProperty() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) return;

    setState(() => isLoading = true);
    final imageUrl = await _uploadImage();

    final data = {
      'name': nameController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0,
      'ownerId': user!.uid,
      'imageUrl': imageUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (widget.propertyId == null) {
      await firestore.collection('properties').add(data);
    } else {
      await firestore
          .collection('properties')
          .doc(widget.propertyId)
          .update(data);
    }

    setState(() => isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.propertyId == null ? 'Add Property' : 'Edit Property')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Property Name'),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price (₹)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    ),
                    if (imageFile != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Image.file(imageFile!, height: 150),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProperty,
                      child: const Text('Save Property'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
