import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'recipe_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _recipes = [];
  bool _isLoading = false;
  List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Snacks'];
  List<dynamic> _popularRecipes = [];

  Future<void> fetchRecipes(String query) async {
    setState(() => _isLoading = true);
    const String apiKey = "847fd3f6258f4e1daf07830bc33df118";
    final String url =
        "https://api.spoonacular.com/recipes/complexSearch?query=$query&number=10&apiKey=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _recipes = data['results']);
      } else {
        throw Exception("Failed to load recipes");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> fetchPopularRecipes() async {
    const String apiKey = "847fd3f6258f4e1daf07830bc33df118";
    final String url = "https://api.spoonacular.com/recipes/random?number=5&apiKey=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _popularRecipes = data['recipes']);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPopularRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Recipe Finder'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for recipes...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: Colors.deepOrange),
                  onPressed: () => fetchRecipes(_searchController.text),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Popular Recipes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _popularRecipes.isEmpty
                ? Center(child: CircularProgressIndicator(color: Colors.deepOrange))
                : SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _popularRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _popularRecipes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipePage(recipeId: recipe['id']),
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              children: [
                                Image.network(
  "https://spoonacular.com/recipeImages/${recipe['id']}",
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(recipe['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 20),
            Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: categories.map((category) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                  onPressed: () => fetchRecipes(category),
                  child: Text(category, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.deepOrange))
                : Expanded(
                    child: _recipes.isEmpty
                        ? Center(child: Text("No recipes found", style: TextStyle(fontSize: 16)))
                        : ListView.builder(
                            itemCount: _recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = _recipes[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: Image.network(
  "https://spoonacular.com/recipeImages/${recipe['id']}",
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
),


                                  title: Text(recipe['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipePage(recipeId: recipe['id']),
                                        ),
                                      );
                                    },
                                    child: Text("View", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}