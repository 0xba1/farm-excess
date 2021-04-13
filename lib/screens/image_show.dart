import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({Key key, @required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragDown: (details) {
          Navigator.pop(context);
        },
        child: SafeArea(
          child: Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (_, __) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ));
  }
}
