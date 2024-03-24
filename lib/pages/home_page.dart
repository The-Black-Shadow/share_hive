import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Hive'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen or any other screen after logout.
    Navigator.of(context).pushReplacementNamed('/login');
  } catch (e) {
    print('Error logging out: $e');
    // Handle error, if any.
  }
}
