import 'package:flutter/material.dart';

class CircleImageWidget extends StatelessWidget {
  final String imageName;

  const CircleImageWidget(
      {Key? key, required this.imageName}) 
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 100.0,
      child: Image.network(imageName),
    );
  }
}