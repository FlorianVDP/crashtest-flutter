import 'package:flutter/material.dart';

class BooleanPage extends StatefulWidget {
  const BooleanPage({super.key});
  @override
  _BooleanPageState createState() => _BooleanPageState();
}

class _BooleanPageState extends State<BooleanPage> {
  bool _isTrue = false;
  void _toggle() {
    setState(() {
      _isTrue = !_isTrue;
    });
  }

  onPressed() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      //center content
      child: Column(
        children: [
          Center(
            //column of widgets
            child: Column(
              //center widgets in column
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //text widget
                Text(
                  '$_isTrue',
                  style: Theme.of(context).textTheme.headline4,
                ),
                //Toggle switch button
                Switch(
                  value: _isTrue,
                  onChanged: (bool value) {
                    setState(() {
                      _isTrue = value;
                    });
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// Searchdelegate