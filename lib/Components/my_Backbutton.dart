import 'package:flutter/material.dart';

class MyBackbutton extends StatelessWidget {
  const MyBackbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child:
          Container(child: Icon(Icons.arrow_back), padding: EdgeInsets.all(25)),
    );
  }
}
