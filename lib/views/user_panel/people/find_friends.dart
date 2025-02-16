import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kinbo/model/buddy.dart';
import 'package:kinbo/model/user.dart';
import 'package:kinbo/services/database.dart';
import 'package:kinbo/views/shared/input_decoration.dart';
import 'package:kinbo/views/shared/list_builder.dart';
import 'package:kinbo/views/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Find friend page, where a user can search for his friend.

class FindFriends extends StatefulWidget {
  // final String uid;
  // FindFriends(this.uid);
  //const FindFriends({ Key? key }) : super(key: key);

  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  String searchName = "";

  @override
  Widget build(BuildContext context) {
    //final _buddies = Provider.of<List<Buddy>>(context) ?? [];
    final _user = Provider.of<UserObj>(context);

    //final _userData = Provider.of<_userData>(context);
    return StreamBuilder<List<Buddy>>(
        stream: DatabaseService(uid: _user.uid, query: searchName).buddySearch,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Buddy>? _buddies = snapshot.data;
            return Column(
              children: [
                searchBox(),
                (_buddies!.length == 0)
                    // if there is no user on list,
                    // shows this text.
                    ? Container(
                        decoration: BoxDecoration(
                            //color: Colors.greenAccent,
                            border: Border.all(
                                color: Colors.pink[300] ?? Colors.pink,
                                width: 1.5)),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(30),
                        //color: Colors.green[100],
                        child: Text(
                          """"To find a friend, enter their exact username. We value your privacy, so we keep profiles hidden to prevent unwanted followers. Only users who know the correct username can find a specific profile.

For your security, we suggest creating a unique and complex username that's difficult to guess. Share it only with people you trust. If you have any suggestions, please email us at smsehab0@gmail.com." 
                    """,
                          //textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          )),
                        ))

                    // otherwise shows the result list
                    : Expanded(
                        child: ListBuilder(
                          _buddies,
                          _user.uid ?? '',
                          true,
                        ),
                      ),
              ],
            );
          } else {
            return Loading();
          }
        });
  }

  // search box to search user by name
  Widget searchBox() {
    return Card(
        //margin: EdgeInsets.fromLTRB(8.00, 0, 8.00, 0),
        child: TextFormField(
            inputFormatters: <TextInputFormatter>[
          LowerCaseTextFormatter(),
          //FilteringTextInputFormatter.deny(RegExp("[A-Z]")),
        ],
            cursorColor: Colors.indigo[400],
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.indigo[400]),
                hintText: 'Search...',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.indigo[400] ?? Colors.indigo, width: 2.0),
                )),
            onChanged: (val) {
              setState(() {
                searchName = val;
              });
            }));
  }
}

