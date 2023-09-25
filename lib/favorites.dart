import 'package:flutter/material.dart';
import 'package:pokedex/home.dart';
import 'package:provider/provider.dart';

class Favorites extends ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => _items;

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  bool contains(Item item) {
    return _items.contains(item);
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<Favorites>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: ListView.builder(
        itemCount: favorites.items.length,
        itemBuilder: (context, index) {
          final item = favorites.items[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Image.network(item.image, width: 120, height: 120),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.name),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text('#${item.number}'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
