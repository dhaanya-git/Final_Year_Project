import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditPropertyScreen extends StatefulWidget {
  final String propertyId;
  final Map<String, dynamic> propertyData;

  const EditPropertyScreen({
    super.key,
    required this.propertyId,
    required this.propertyData,
  });

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController placeController;
  late TextEditingController acresController;
  late TextEditingController historyController;
  late TextEditingController priceController;
  late TextEditingController locationController;
  late TextEditingController documentController;
  File? imageFile;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    placeController = TextEditingController(text: widget.propertyData['place']);
    acresController = TextEditingController(text: widget.propertyData['acres']);
    historyController =
        TextEditingController(text: widget.propertyData['history']);
    priceController = TextEditingController(text: widget.propertyData['price']);
    locationController =
        TextEditingController(text: widget.propertyData['location']);
    documentController =
        TextEditingController(text: widget.propertyData['document']);
    imageUrl = widget.propertyData['image'];
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) return;
    final ref =
        FirebaseStorage.instance.ref('property_images/${widget.propertyId}');
    await ref.putFile(imageFile!);
    final url = await ref.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  Future<void> saveProperty() async {
    if (!_formKey.currentState!.validate()) return;

    if (imageFile != null) {
      await uploadImage();
    }

    final updatedData = {
      'place': placeController.text.trim(),
      'acres': acresController.text.trim(),
      'history': historyController.text.trim(),
      'price': priceController.text.trim(),
      'location': locationController.text.trim(),
      'document': documentController.text.trim(),
      'image': imageUrl ?? '',
    };

    await FirebaseFirestore.instance
        .collection('properties')
        .doc(widget.propertyId)
        .update(updatedData);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Property updated')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Property'),
          backgroundColor: Colors.lightBlue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : (imageUrl != null && imageUrl != ''
                              ? NetworkImage(imageUrl!)
                              : null) as ImageProvider<Object>?,
                      child: (imageFile == null &&
                              (imageUrl == null || imageUrl == ''))
                          ? const Icon(Icons.landscape, size: 60)
                          : null,
                    ),
                    IconButton(
                        icon: const Icon(Icons.edit), onPressed: pickImage),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: placeController,
                decoration: const InputDecoration(labelText: 'Place'),
                validator: (value) => value!.isEmpty ? 'Enter place' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: acresController,
                decoration: const InputDecoration(labelText: 'Acres'),
                validator: (value) => value!.isEmpty ? 'Enter acres' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: historyController,
                decoration: const InputDecoration(labelText: 'History'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location URL'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: documentController,
                decoration: const InputDecoration(labelText: 'Document URL'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: saveProperty,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
