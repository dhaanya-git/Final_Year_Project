import 'package:flutter/material.dart';
import '../models/land.dart';

class LandCard extends StatelessWidget {
  final Land land;
  final VoidCallback onTap;
  const LandCard({required this.land, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(land.title),
            subtitle: Text(land.location),
            onTap: onTap));
  }
}
