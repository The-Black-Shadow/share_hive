import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_hive/components/textfield.dart';
import 'package:share_hive/components/wall_posts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Share Hive',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontFamily: GoogleFonts.pacifico().fontFamily,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('User Posts')
                    .orderBy(
                      'timestamp',
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children:
                          List.generate(snapshot.data!.docs.length, (index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                        );
                      }),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextfield(
                    controller: textController,
                    hint: 'Write something on the wall...',
                    obscureText: false,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    PostMessage();
                  },
                ),
              ],
            ),
          ),
          Text('Logged In as ${user?.email}'),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  void PostMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': user?.email,
        'Message': textController.text,
        'timestamp': Timestamp.now(),
      });
      textController.clear();
    }
  }
}
