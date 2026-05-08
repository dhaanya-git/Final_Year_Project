import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class AddEditPropertyScreen extends StatefulWidget {
  final String? propertyId; // null for add, non-null for edit
  const AddEditPropertyScreen({super.key, this.propertyId});

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final historyController = TextEditingController();
  final urlController = TextEditingController();
  final acresController = TextEditingController();

  List<File> imageFiles = [];
  List<File> documentFiles = [];
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
      locationController.text = data['location'] ?? '';
      historyController.text = data['history'] ?? '';
      urlController.text = data['locationUrl'] ?? '';
      acresController.text = data['acres']?.toString() ?? '';
    }
  }

  Future<void> _pickImages() async {
    try {
      final picked = await ImagePicker().pickMultiImage();
      if (picked != null) {
        setState(() {
          imageFiles.addAll(picked.map((e) => File(e.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error picking images: $e')));
    }
  }

  Future<void> _pickDocuments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        setState(() {
          documentFiles.addAll(result.paths.map((path) => File(path!)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error picking documents: $e')));
    }
  }

  Future<List<String>> _uploadFiles(List<File> files, String pathPrefix) async {
    List<String> urls = [];
    for (var file in files) {
      final ref = FirebaseStorage.instance.ref().child(
          '$pathPrefix/${user!.uid}/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  void _saveProperty() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name and Price are required')));
      return;
    }

    setState(() => isLoading = true);

    final imageUrls = await _uploadFiles(imageFiles, 'property_images');
    final documentUrls =
        await _uploadFiles(documentFiles, 'property_documents');

    final data = {
      'name': nameController.text.trim(),
      'price': double.tryParse(priceController.text.trim()) ?? 0,
      'location': locationController.text.trim(),
      'history': historyController.text.trim(),
      'locationUrl': urlController.text.trim(),
      'acres': double.tryParse(acresController.text.trim()) ?? 0,
      'ownerId': user!.uid,
      'imageUrls': imageUrls,
      'documentUrls': documentUrls,
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
        title:
            Text(widget.propertyId == null ? 'Add Property' : 'Edit Property'),
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.yellow[100],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow)))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(nameController, 'Property Name'),
                    const SizedBox(height: 10),
                    _buildTextField(priceController, 'Price (₹)',
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    _buildTextField(locationController, 'Location'),
                    const SizedBox(height: 10),
                    _buildTextField(historyController, 'Land History'),
                    const SizedBox(height: 10),
                    _buildTextField(urlController, 'Location URL'),
                    const SizedBox(height: 10),
                    _buildTextField(acresController, 'Acres',
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent),
                      onPressed: _pickImages,
                      child: const Text('Pick Images',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: imageFiles
                          .map(
                              (file) => Image.file(file, width: 80, height: 80))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent),
                      onPressed: _pickDocuments,
                      child: const Text('Pick Documents',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: documentFiles
                          .map((file) => Text(file.path.split('/').last,
                              style: const TextStyle(color: Colors.black)))
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent),
                      onPressed: _saveProperty,
                      child: const Text('Save Property',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.yellow[200],
        border: OutlineInputBorder(),
      ),
    );
  }
}
