import 'dart:developer';

import 'package:flutter/material.dart';

import '../pages/block_page.dart';
import '../pages/boolean_page.dart';
import '../pages/generated_list.dart';
import '../widgets/default_drawer.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class DefaultLayout extends StatefulWidget {
  const DefaultLayout({super.key, required this.title});
  final String title;

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    GeneratedList(),
    BlockPage(),
    BooleanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: const default_drawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.reorder),
              label: "List",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: "Blocks",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.toggle_off),
              label: "Bool",
              backgroundColor: Colors.blue),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
      ),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              tooltip: 'Search',
              child: const Icon(Icons.search),
            )
          : null,
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  Future<List<dynamic>> fetchSearchResults() async {
    var reponse = await Dio().get('https://pokeapi.co/api/v2/pokemon');
    return reponse.data['results']
        .map<dynamic>((item) => item['name'])
        .toList();
  }

  Future<List<dynamic>>? _items;

  goToGoogle(search) async {
    String url = "https://www.google.com/search?q=$search";
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchSearchResults(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                onTap: () => goToGoogle(snapshot.data![index]),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _items = fetchSearchResults();

    return FutureBuilder<List<dynamic>>(
      future: _items,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> matchQuery = [];

          if (query.isNotEmpty) {
            for (var poke in snapshot.data!) {
              if (poke.toLowerCase().contains(query.toLowerCase())) {
                matchQuery.add(poke);
              }
            }
          }

          return ListView.builder(
            itemCount:
                query.isNotEmpty ? matchQuery.length : snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(query.isNotEmpty
                    ? matchQuery[index]
                    : snapshot.data![index]),
                onTap: () => goToGoogle(matchQuery[index]),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
