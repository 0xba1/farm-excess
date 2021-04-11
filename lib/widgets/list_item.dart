import 'package:farm_excess/screens/image_show.dart';
import 'package:farm_excess/values/my_colors.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    @required this.image,
    this.location,
    this.title,
  }) : super(key: key);
  final Image image;
  final String location;
  final String title;

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
                              builder: (context) => ShowImage(image: image)))
                    },
                    child: ClipRRect(
                      child: image,
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
