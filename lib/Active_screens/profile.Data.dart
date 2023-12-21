import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internship_project/Active_screens/Profile_screen.dart';

import '../models/model_class.dart';

class ProfileData extends StatefulWidget {
  ProfileData({super.key, required this.modelClass});
  final ModelClass? modelClass;

  @override
  State<ProfileData> createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  final auth = FirebaseAuth.instance;
  var name_control = TextEditingController();
  var phone_control = TextEditingController();
  var country_control = TextEditingController();
  // ModelClass?  modelClass;
  XFile? images;
  //pick image function
  final ImagePicker imagePicker = ImagePicker();
  Country? selectedCountry;
  String imageurl="";

  @override
  void initState() {
    //if model class is not empty  and we are adding data then set data on textfields we created in show data screen(show data widgets)
    if (widget.modelClass != null) {
      name_control.text = widget.modelClass!.name;
      phone_control.text = widget.modelClass!.phone;
      country_control.text = widget.modelClass!.country;
        imageurl = widget.modelClass!.image;
      // images = XFile(widget.modelClass!.image);
      super.initState();
    }
  }

  // Function to upload an image to Firebase Cloud Storage
  Future<String> uploadImage(XFile file, String userId) async {
    final storageRef =
        FirebaseStorage.instance.ref().child('user_data_images/$userId.png');
    print(file.path);
    // File(file.path) converts the XFile to a regular File object to be uploaded.
    final uploadTask = await storageRef.putFile(
        File(file.path),
        SettableMetadata(contentType: "image/png")); //uploading task refers to task of uploading data to remote server
    if (uploadTask.state == TaskState.success) {
      ///This condition checks if the upload task was successful. If the upload was successful, it means the image is now stored in Firebase Storage.
       imageurl = await storageRef.getDownloadURL();

      return imageurl;
    } else {
      throw PlatformException(code: "404", message: "no download link found");
    }
  }

  Future<XFile?> pickImage(ImageSource source) async {
    XFile? file = await imagePicker.pickImage(source: source); //Xfile is the class in photomanager package of dart and contain information related to assets like file size etc
    if (file != null) {
      return file;
    } else {
      print('Image not Selected');
    }
    return null;
  }

//select image from gallery
  selectImage() async {
    XFile? image = await pickImage(ImageSource.gallery); //XFile is used to represent image data into memory

    print(images?.mimeType);
    setState(() {
      images = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Profile Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(widget.modelClass == null ? "Add User" : "Update User"),
            Stack(
              children: <Widget>[
                if (images != null)
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: FileImage(File(images!.path)),
                  )
                else
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage( widget.modelClass?.image ??
                        "https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg"),
                  ),
                Positioned(
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(Icons.add_a_photo),
                  ),
                  bottom: -10,
                  left: 80,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TextField(
                    controller: name_control,
                    decoration: InputDecoration(
                        hintText: "Name", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: phone_control,
                    decoration: InputDecoration(
                        hintText: "Phone number", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: country_control,
                    decoration: InputDecoration(
                      hintText: 'Country',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        onSelect: (Country country) {
                          setState(() {
                            selectedCountry = country;
                            country_control.text = country.displayName; // Set the text in the TextField
                          });
                          print('${country.displayName}');
                        },
                      );
                    },
                    child: Text('Select Country'),
                  ),

                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      var uid = FirebaseAuth.instance.currentUser!.uid;
                      final doc = FirebaseFirestore.instance.collection("usersData").doc(uid);

                      if (images != null && widget.modelClass == null) {
                        //handle the case when images are not null and modelClass is null
                        final url = await uploadImage(images!, doc.id);

                        final modelclass = ModelClass(
                          uid: doc.id,
                          name: name_control.text,
                          phone: phone_control.text,
                          country: country_control.text,
                          image: url,
                        );

                        await doc.set(modelclass.toMap());
                        print("Data set successfully");
                      }  else if (widget.modelClass != null) {
                        //handle the case when modelClass is not null
                        String imageUrl = widget.modelClass!.image;

                        // Check if a new image is selected
                        if (images != null) {
                          // Upload a new image and get the new URL
                          imageUrl = await uploadImage(images!, doc.id);
                        }

                        // Update Firestore document with the new data and image URL
                        final modelclass = ModelClass(
                          uid: doc.id,
                          name: name_control.text,
                          phone: phone_control.text,
                          country: country_control.text,
                          image: imageUrl,
                        );

                        await doc.set(modelclass.toMap());
                        print("Data updated successfully");
                      }
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                            (route) => false, // This removes all routes from the stack
                      );
                    },
                    child: Text('Save'),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

