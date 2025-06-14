import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Page', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  image: (user?.photoURL == null || user!.photoURL!.isEmpty)
                      ? const NetworkImage(
                      'https://play-lh.googleusercontent.com/38AGKCqmbjZ9OuWx4YjssAz3Y0DTWbiM5HB0ove1pNBq_o9mtWfGszjZNxZdwt_vgHo=w480-h960-rw')
                      : NetworkImage(user.photoURL!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user?.uid ?? 'Anonymous UID', // user.id로 표현
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              user?.email ?? 'No Email',
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Text(
              user?.displayName ?? 'SEEUN PARK', // user.name
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '재미있게 소통하며 소비 통제 하자',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
