import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:kinbo/services/database.dart';


// show the profile image box.
// if there is image, displays it,
// otherwise shows 'upload image' icon.
// on tap, an upload page shows up
// to select image from gallery or by camera.
// After then uploads the image.


class UploadPhoto extends StatefulWidget {
  //const UploadPhoto({ Key? key }) : super(key: key);
  String _prevImage;
  final String uid;

  UploadPhoto(this._prevImage, this.uid);

  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    String _image = image!.path;
    uploadImage(widget.uid, _image);

  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    String _image = image!.path;
    uploadImage(widget.uid, _image);
  }

  Future<void> uploadImage(String uid, String _image) async {
    if (_image != null) {
      firebase_storage.Reference imageStorage =
          firebase_storage.FirebaseStorage.instance.ref().child('images/$uid');

      await imageStorage.putFile(File(_image));
      print(_image);
      print('File Uploaded');

      String imageUrlFromCloud = await imageStorage.getDownloadURL();
      if (imageUrlFromCloud != null) {
        await DatabaseService(uid: uid)
            .updateUserData(image: imageUrlFromCloud);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    //
    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromGallery();
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

//
//
    //_image = widget._prevImage;
    return GestureDetector(
      onTap: () {
        _showPicker(context);
      },
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Color(0xffFDCF09),
        child: widget._prevImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.network(
                  widget._prevImage,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
            // : _image != null
            //     ? ClipRRect(
            //         borderRadius: BorderRadius.circular(60),
            //         child: Image.file(
            //           File(_image),
            //           width: 120,
            //           height: 120,
            //           fit: BoxFit.fitHeight,
            //         ),
            //       )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(60)),
                width: 120,
                height: 120,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey[800],
                ),
              ),
      ),
    );
  }
}
