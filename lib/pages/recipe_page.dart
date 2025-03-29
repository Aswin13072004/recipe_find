import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipePage extends StatefulWidget {
  final int recipeId;
  const RecipePage({super.key, required this.recipeId});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Map<String, dynamic>? _recipeDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails();
  }

  Future<void> fetchRecipeDetails() async {
    const String apiKey = "847fd3f6258f4e1daf07830bc33df118";
    final String url =
        "https://api.spoonacular.com/recipes/${widget.recipeId}/information?apiKey=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _recipeDetails = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load recipe details");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Recipe Details"),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.deepOrange))
          : _recipeDetails == null
              ? Center(child: Text("Recipe not found"))
              : GestureDetector(
                  onVerticalDragUpdate: (details) {},
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _recipeDetails!['title'],
                              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                            ),
                            SizedBox(height: 20),
                            Text("🍽 Ingredients:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            ...(_recipeDetails!['extendedIngredients'] as List)
                                .map((ingredient) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Text("• ${ingredient['original']}", style: TextStyle(fontSize: 16)),
                                    ))
                                ,
                            SizedBox(height: 20),
                            Text("📖 Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text(
                              _recipeDetails!['instructions'] ?? "No instructions available",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
