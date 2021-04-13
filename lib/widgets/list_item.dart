import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_excess/screens/image_show.dart';
import 'package:farm_excess/values/my_colors.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    @required this.imageUrl,
    this.location,
    this.title,
    this.description,
    this.email,
    this.timestamp,
  }) : super(key: key);
  final String imageUrl;
  final String location;
  final String title;
  final String description;
  final String email;
  final int timestamp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: MyColors.greytaupe,
        ),
        Container(
            margin: EdgeInsets.only(
              top: 12,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowImage(imageUrl: imageUrl)))
                    },
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (_, __) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    splashColor: MyColors.greytaupe,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: MyColors.mud,
                            size: 20,
                          ),
                          Text(
                            "At $location",
                            style: TextStyle(color: MyColors.mud, fontSize: 18),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.mail,
                          color: MyColors.mughalgreen,
                        ),
                        onPressed: () {},
                        tooltip: "Send email to farmer.",
                      )
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
