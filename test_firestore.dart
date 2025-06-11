import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestFirestore extends StatefulWidget {
  const TestFirestore({super.key});

  @override
  State<TestFirestore> createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TestFirestore> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tes Firestore')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final user = <String, dynamic>{
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815,
          };

          db
              .collection("users")
              .doc("data1")
              .set(user)
              .then((_) => print('DocumentSnapshot added!'));
        },
        child: Icon(Icons.add), // ✅ dipindah ke dalam FloatingActionButton
      ),
      body: Center(child: Text("Klik tombol tambah")),
    );
  }
}
