import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/views/shared/dialog_box.dart';
import 'package:kinbo/views/shared/loading.dart';


//List builder to show a list of specific users 
// with their name, bio, image on a card.

class ListBuilder extends StatefulWidget {
  final List buddy;
  final String user;
  final bool heart;
  ScrollPhysics ? physics  = ScrollPhysics();
  ListBuilder(this.buddy, this.user, this.heart, {this.physics});
  //const ListBuilder({ Key? key }) : super(key: key);

  @override
  _ListBuilderState createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) {
    final _buddies = widget.buddy;
    if (_buddies != null || _buddies.isNotEmpty) {
      return ListView.builder(
        physics: widget.physics,
        shrinkWrap: true,
        itemCount: _buddies.length,
        itemBuilder: (context, index) {
          if (_buddies[index].uid != widget.user) {
            return listTile(_buddies[index], widget.user);
          } else
            return SizedBox(height: 0.0);
        },
      );
    } else {
      return Loading();
    }
  }



  // ListTile for every user. 

  Widget listTile(buddy, String myUid) {
    List friendz = buddy.friends ?? [];
    bool alreadyFollowed = friendz != null ? friendz.contains(myUid) : false;

    return Padding(
      padding: EdgeInsets.only(top: 2.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(13.00, 2.00, 13.00, 2.00),
        child: ListTile(
          leading: CircleAvatar(
            radius: 27,
            backgroundColor: Color(0xffFDCF09),
            child: buddy.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      buddy.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    width: 100,
                    height: 100,
                  ),
          ),
          title: Text(
            buddy.name,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                //fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          subtitle: Text(buddy.bio,
              style: GoogleFonts.getFont('Lato'),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
          trailing: (widget.heart == true)
              ? IconButton(
                  // NEW from here...
                  icon: alreadyFollowed
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  color: alreadyFollowed ? Colors.indigo[400] : null,
                  onPressed: () {
                    setState(() {
                      if (alreadyFollowed) {
                        friendz.remove(myUid);
                        DatabaseService(uid: buddy.uid)
                            .updateUserData(friends: friendz);
                      } else {
                        friendz.add(myUid);
                        DatabaseService(uid: buddy.uid)
                            .updateUserData(friends: friendz);
                      }
                    });
                  },
                )
              : SizedBox(),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogBox(
                    title: buddy.name,
                    descriptions: buddy.bio,
                    image: buddy.image,
                  );
                });
          },
        ),
      ),
    );
  }
}
