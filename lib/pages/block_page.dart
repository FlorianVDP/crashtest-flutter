import 'package:flutter/material.dart';

class BlockPage extends StatelessWidget {
  const BlockPage({super.key});
  // Create random function to generate random colors

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            height: 100,
            width: 100,
          ),
          Container(
            color: Colors.green,
            height: 1000,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                // Random color
                color: Colors.primaries[index % Colors.primaries.length],
                height: 100,
                width: 100,
                margin: const EdgeInsets.all(10),
              ),
              itemCount: 100,
            ),
          ),
        ],
      ),
    );
  }
}
