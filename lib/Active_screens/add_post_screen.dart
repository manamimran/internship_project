import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../screens/provider_class.dart';

class AddPostScreen extends StatefulWidget{
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _selectedImage;                        //A variable that holds the selected image file. Initially, it's null as no image is selected.
  bool isUploading = false;                    // A boolean flag to track whether an image is currently being uploaded.
  //pick image function
  final ImagePicker imagePicker = ImagePicker();


  //function for pick image from gallery
  Future<void> pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) {
      // No image selected.
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);         //The picked image is then stored in the _selectedImage variable
    });
  }
  //function for pick image from camera
  Future<void> pickImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      // No image selected.
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);         //The picked image is then stored in the _selectedImage variable
    });
  }

  //function for uploadImage
  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      // No image to upload.
      return;
    }
    setState(() {
      isUploading = true;
    });
  }

  // Function to upload an image to Firebase Cloud Storage
  Future<String> uploadImage(File file, String userId) async {
    final storageRef =
    FirebaseStorage.instance.ref().child('user_data_images/$userId.png');
    print(file.path);
    // File(file.path) converts the XFile to a regular File object to be uploaded.
    final uploadTask = await storageRef.putFile(
        File(file.path),
        SettableMetadata(
            contentType:
            "image/png")); //uploading task refers to task of uploading data to remote server
    if (uploadTask.state == TaskState.success) {
      ///This condition checks if the upload task was successful. If the upload was successful, it means the image is now stored in Firebase Storage.
      String url = await storageRef.getDownloadURL();
      return url;
    } else {
      throw PlatformException(code: "404", message: "no download link found");
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Text('Add Post'),
          ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage == null
                  ? Text('No image selected.')
                  : SizedBox(
                  height: 400,
                  width: 500,
                  child: Image.file(_selectedImage!)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (isUploading ? null : pickImageFromGallery),
                child: Text('Pick Image from Gallery'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (isUploading ? null : pickImageFromCamera),
                child: Text('Pick Image from Camera'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedImage != null) {
                    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
                    String imageUrl = await uploadImage(_selectedImage!, imageName);
                    print(imageUrl);

                    await Provider.of<PostProvider>(context, listen: false)
                        .addPost("Post content", imageUrl);

                    Navigator.pop(context);
                  } else {
                    // Show an error message or handle the case when no image is selected
                  }
                },
                child: Text('Upload'),
              ),
            ],
          ),
        ));
    }
  }
