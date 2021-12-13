import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  ImageDisplay({this.imageUrl});
  final imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image(
        image: NetworkImage(imageUrl)
      )
      )
      
    );
  }
}