import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_excess/screens/add_ad.dart';
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
        onPressed: () => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddAd()))
        },
        child: Icon(
          Icons.add,
        ),
        tooltip: "Add a new ad!",
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ads")
            .orderBy("timestamp", descending: true)
            .snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(
              child: CircularProgressIndicator(),
            );
          var data = snapshot.data.docs;
          print("****************$data****************");
          return ListView.builder(
            itemBuilder: (_, index) {
              return ListItem(
                title: data[index]['title'],
                imageUrl: data[index]['imageUrl'],
                location: data[index]['location'],
                description: data[index]['description'],
                email: data[index]['email'],
                timestamp: data[index]['timestamp'],
              );
            },
            itemCount: data.length,
          );
        },
      ),
    );
  }
}
