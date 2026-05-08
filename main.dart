import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartlease_new/screens/NotificationsScreen.dart';
import 'package:smartlease_new/screens/add_property_screen.dart';
import 'package:smartlease_new/screens/property_detail.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/owner_home.dart';
import 'screens/farmer_home.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartLease',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/ownerHome': (context) => const OwnerHome(),
        '/farmerHome': (context) => const FarmerHome(),
        '/profile': (context) => const ProfileScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/addEditProperty': (context) => const AddEditPropertyScreen(),
        '/propertyDetail': (context) => const PropertyDetailScreen(
            propertyId: ''), // handle propertyId dynamically
      },
    );
  }
}
