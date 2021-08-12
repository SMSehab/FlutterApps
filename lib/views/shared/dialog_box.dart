import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';





// when the name of a certain user tapped, 
// this dialog box shows up with user name, 
// profile picture, and descriptions.
class DialogBox extends StatefulWidget {
  final String title, descriptions, image;

  const DialogBox({Key key, this.title, this.descriptions, this.image})
      : super(key: key);

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 230.00,
          width: 340.00,
          margin: EdgeInsets.only(top: 30, left: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Padding(
            padding: EdgeInsets.only(
              left: 25.00,
              right: 25.00,
              bottom: 25.00,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 90,
                  padding: EdgeInsets.only(
                    left: 80.00,
                  ),
                  child: Center(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  height: 110,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.descriptions,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14),
                      ),
                      textAlign: TextAlign.center,
                      //softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          //left: 112,
          // right: 63,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: (widget.image != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.all(
                        Radius.circular(Constants.avatarRadius)),
                    child: Image.network(
                      widget.image,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(
                        Radius.circular(Constants.avatarRadius),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 60;
}
