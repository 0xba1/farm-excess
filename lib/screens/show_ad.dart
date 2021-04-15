import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_excess/values/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowAd extends StatelessWidget {
  const ShowAd({
    Key key,
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.location,
    @required this.email,
    @required this.timestamp,
  }) : super(key: key);
  final String title;
  final String imageUrl;
  final String description;
  final String location;
  final String email;
  final int timestamp;

  void launchUrl(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  String getTime(int msFromEpoch) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(msFromEpoch);
    return "${time.day} ${time.month} ${time.year}   ${time.hour}:${time.minute}:${time.second}";
  }

  String elipsis(String sentence, int maxLength) {
    if (sentence.length > maxLength)
      return "${sentence.substring(0, maxLength + 1)}...";

    return sentence;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${elipsis(title, 10)}",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        backgroundColor: MyColors.lighttaupe,
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (_, __) => Center(
              child: CircularProgressIndicator(),
            ),
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
                onPressed: () {
                  try {
                    launchUrl("mailto:$email");
                  } catch (e) {
                    print(e);
                  }
                },
                tooltip: "Send email to farmer.",
              )
            ],
          ),
          Container(
            child: Text(description),
          ),
          Container(
            child: Text(getTime(timestamp)),
          )
        ],
      ),
    );
  }
}
