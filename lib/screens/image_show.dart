import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({Key key, @required this.image}) : super(key: key);
  final Image image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragDown: (details) {
          Navigator.pop(context);
        },
        child: SafeArea(
          child: Center(
            child: image,
          ),
        ));
  }
}
