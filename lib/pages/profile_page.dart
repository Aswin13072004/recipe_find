import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.deepOrange),
      body: Center(child: Text("User Profile Settings", style: TextStyle(fontSize: 18))),
    );
  }
}
