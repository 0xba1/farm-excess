import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_excess/values/my_colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddAd extends StatefulWidget {
  AddAd({Key key}) : super(key: key);

  @override
  _AddAdState createState() => _AddAdState();
}

class _AddAdState extends State<AddAd> {
  PickedFile imageFile;
  String imageDownloadUrl = "";
  TextEditingController _titleController;
  String titleErrorText;
  TextEditingController _descriptionController;
  String descriptionErrorText;
  TextEditingController _locationController;
  String locationErrorText;

  CollectionReference ads = FirebaseFirestore.instance.collection('ads');

  void _openCamera(BuildContext context) async {
    // To choose image by taking a photo with a camera
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile;
    });
    uploadImageToFirebase(context);
  }

  void _openGallery(BuildContext context) async {
    // To choose image from previously taken images
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile;
    });
    uploadImageToFirebase(context);
  }

  Future _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: MyColors.mud),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: MyColors.mud,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: MyColors.mud,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: MyColors.mud,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera_alt_rounded,
                      color: MyColors.mud,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = imageFile.path;
    File file = File(fileName);
    Reference ref = FirebaseStorage.instance.ref('image_uploads/$fileName');

    try {
      await ref.putFile(file);
      imageDownloadUrl = await ref.getDownloadURL();
      print("uploaded");
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  void addAd(
      {String title, String description, String location, String imageUrl}) {
    if (title == "") {
      setState(() {
        titleErrorText = "Please enter a title;";
      });
      return;
    }
    if (description == "") {
      setState(() {
        descriptionErrorText = "Please enter a description;";
      });
      return;
    }
    if (location == "") {
      setState(() {
        locationErrorText = "Please enter a location;";
      });
      return;
    }
    if (imageDownloadUrl == "") {
      print("Upload an image");
      return;
    }

    ads
        .add({
          'title': title,
          'description': description,
          'location': location,
          'imageUrl': imageUrl
        })
        .then((value) => print("Ads Added"))
        .catchError((error) => print("Failed to add ad: $error"));
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 10,
              decoration:
                  InputDecoration(labelText: "Description", errorText: ""
                      // border: OutlineInputBorder(),
                      ),
            ),
            SizedBox(height: 64),
            Center(
              child: Container(
                margin: EdgeInsets.all(12),
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.lighttaupe, width: 2)),
                child: InkWell(
                  onTap: () => _showChoiceDialog(context),
                  child: Icon(
                    Icons.image,
                    color: MyColors.lighttaupe,
                    size: 64,
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {},
              child: Text("Create New Ad"),
            )
          ],
        ),
      ),
    );
  }
}
