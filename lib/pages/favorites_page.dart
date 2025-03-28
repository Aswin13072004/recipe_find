import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("Favorites"), backgroundColor: Colors.deepOrange),
      body: Center(child: Text("Your favorite recipes will appear here!", style: TextStyle(fontSize: 18))),
    );
  }
}
