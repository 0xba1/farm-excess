import 'package:farm_excess/values/my_colors.dart';
import 'package:farm_excess/widgets/list_item.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FarmXcess",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        backgroundColor: MyColors.lighttaupe,
      ),
      backgroundColor: MyColors.lightgrey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.mughalgreen,
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
        tooltip: "Add a new ad!",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListItem(image: Image.asset("assets/images/farm_produce.jpg")),
            ListItem(image: Image.asset("assets/images/farm_produce.jpg")),
            ListItem(image: Image.asset("assets/images/farm_produce.jpg")),
            ListItem(image: Image.asset("assets/images/farm_produce.jpg")),
          ],
        ),
      ),
    );
  }
}
