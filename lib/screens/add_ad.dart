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
  TextEditingController _emailController;
  String emailErrorText;

  StateNotifier stateNotifier = StateNotifier();

  CollectionReference adsRef = FirebaseFirestore.instance.collection('ads');

  void _openCamera(BuildContext context) async {
    // To choose image by taking a photo with a camera
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile;
    });
    stateNotifier.changeState("loading");
    await uploadImageToFirebase(context);
    if (imageDownloadUrl != "") stateNotifier.changeState("done");
  }

  void _openGallery(BuildContext context) async {
    // To choose image from previously taken images
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile;
    });
    stateNotifier.changeState("loading");
    await uploadImageToFirebase(context);
    if (imageDownloadUrl != "") stateNotifier.changeState("done");
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
                      Navigator.pop(context);
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
                      Navigator.pop(context);
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
    try {
      String fileName = imageFile.path;
      File file = File(fileName);

      Reference ref = FirebaseStorage.instance
          .ref('image_uploads/${Timestamp.now().microsecondsSinceEpoch}');
      try {
        await ref.putFile(file);

        imageDownloadUrl = await ref.getDownloadURL();
        print("uploaded");
      } on FirebaseException catch (e) {
        print(e);
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  void addAd(
      {@required String title,
      @required String description,
      @required String location,
      @required String imageUrl,
      @required String email,
      @required CollectionReference adsRef}) {
    bool validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      return regex.hasMatch(value);
    }

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
        emailErrorText = "Please enter a location;";
      });
      return;
    }
    if (!validateEmail(email)) {
      setState(() {
        locationErrorText = "Please enter an email;";
      });
      return;
    }
    if (imageDownloadUrl == "") {
      print("Upload an image");
      return;
    }

    adsRef.add({
      'title': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'email': email,
      'timestamp': Timestamp.now().millisecondsSinceEpoch
    }).then((value) {
      print("Ads Added");
      Navigator.pop(context, 1);
    }).catchError((error) => print("Failed to add ad: $error"));
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Ad",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        backgroundColor: MyColors.lighttaupe,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  errorText: titleErrorText,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailErrorText,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.all(8.0),
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: "Location",
                  errorText: locationErrorText,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Description: ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 10,
                    decoration:
                        InputDecoration(errorText: descriptionErrorText),
                  ),
                ),
              ],
            ),
            SizedBox(height: 64),
            Center(
                child: TextButton(
              child: Text(
                "Add Photo",
                style: TextStyle(color: MyColors.lighttaupe, fontSize: 16),
              ),
              onPressed: () => _showChoiceDialog(context),
            )),
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
                    width: 300,
                    child: InkWell(
                        onTap: () => _showChoiceDialog(context),
                        child: Image.file(File(imageFile.path))),
                  );
                }

                return InkWell(
                  onTap: () => _showChoiceDialog(context),
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 64),
            MaterialButton(
              color: MyColors.kellygreen,
              onPressed: () {
                addAd(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    location: _locationController.text,
                    imageUrl: imageDownloadUrl,
                    email: _emailController.text,
                    adsRef: adsRef);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Create New Ad"),
              ),
            ),
            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
