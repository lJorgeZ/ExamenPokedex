import 'package:flutter/material.dart';
import 'package:pokedex/favorites.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
  }

  Future<void> fetchPokemonData() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      for (var result in results) {
        final name = result['name'];
        final number = results.indexOf(result) + 1;
        final imageUrl =
            'https://raw.githubusercontent.com/PokeAPI/sprites/f301664fbbce6ccbe09f9561287e05653379f870/sprites/pokemon/$number.png';

        items.add(Item(name: name, image: imageUrl, number: number));
      }

      setState(() {});
    } else {
      throw Exception('Failed to load Pokemon data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<Favorites>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Elementos'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Center(
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 4,
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(item: item),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Image.network(
                      item.image,
                      fit: BoxFit.fitHeight,
                    ),
                    Text(item.name),
                    Text('#${item.number}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Item {
  final String name;
  final String image;
  final int number;

  Item({required this.name, required this.image, required this.number});
}

class DetailPage extends StatefulWidget {
  final Item item;

  DetailPage({required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Map<String, dynamic>> pokemonData;

  @override
  void initState() {
    super.initState();
    pokemonData = fetchPokemonData(widget.item.name);
  }

  Future<Map<String, dynamic>> fetchPokemonData(String pokemonName) async {
    final response = await http
        .get(Uri.parse("https://pokeapi.co/api/v2/pokemon/$pokemonName"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokémon data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<Favorites>(context);
    final isFavorite = favorites.contains(widget.item);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              if (isFavorite) {
                favorites.remove(widget.item);
              } else {
                favorites.add(widget.item);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: pokemonData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final pokemon = snapshot.data;
            final sprites = pokemon?['sprites'];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Card(
                    child: Image.network(sprites['front_default']),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      children: [
                        Text(widget.item.name),
                        Text('Sprites: '),
                        Image.network(sprites['back_default']),
                        Image.network(sprites['back_shiny']),
                        Image.network(sprites['front_shiny']),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
