import 'package:flutter/material.dart';

class GeneratedList extends StatelessWidget {
  const GeneratedList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text('Item $index'),
        textColor: Colors.black,
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item $index'),
            duration: const Duration(seconds: 1),
          ),
        ),
      ),
      itemCount: 100,
    );
  }
}
