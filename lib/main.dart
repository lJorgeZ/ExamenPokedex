import 'package:flutter/material.dart';
import 'package:pokedex/favorites.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Favorites(),
      child: MaterialApp(
        title: 'Pokedex',
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/favorites': (context) => FavoritesPage(),
        },
      ),
    );
  }
}