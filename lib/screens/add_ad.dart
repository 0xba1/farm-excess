import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farm_excess/values/my_colors.dart';
import 'package:farm_excess/widgets/state_notifier.dart';
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

  StateNotifier stateNotifier = StateNotifier();

  CollectionReference ads = FirebaseFirestore.instance.collection('ads');

  void _openCamera(BuildContext context) async {
    // To choose image by taking a photo with a camera
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile;
    });
    stateNotifier.changeState("loading");
    uploadImageToFirebase(context);
    stateNotifier.changeState("done");
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
      {@required String title,
      @required String description,
      @required String location,
      @required String imageUrl,
      @required CollectionReference adsRef}) {
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

    adsRef
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
                errorText: titleErrorText,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Location",
                errorText: locationErrorText,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                Text("Description"),
                TextField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 10,
                  decoration: InputDecoration(errorText: descriptionErrorText),
                ),
              ],
            ),
            SizedBox(height: 64),
            ValueListenableBuilder(
              valueListenable: stateNotifier.state,
              builder: (context, value, child) {
                if (value == "initial") {
                  return Center(
                    child: Container(
                      margin: EdgeInsets.all(12),
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: MyColors.lighttaupe, width: 2)),
                      child: InkWell(
                        onTap: () => _showChoiceDialog(context),
                        child: Icon(
                          Icons.image,
                          color: MyColors.lighttaupe,
                          size: 64,
                        ),
                      ),
                    ),
                  );
                }

                if (value == "done") {
                  return Container(
                    height: 300,
                    child: Image.file(File(imageFile.path)),
                  );
                }

                return Container(
                  height: 300,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
            MaterialButton(
              onPressed: () {
                addAd(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    location: _locationController.text,
                    imageUrl: imageDownloadUrl,
                    adsRef: ads);
              },
              child: Text("Create New Ad"),
            )
          ],
        ),
      ),
    );
  }
}
