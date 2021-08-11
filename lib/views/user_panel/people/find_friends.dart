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
            List<Buddy> _buddies = snapshot.data;
            return Column(
              children: [
                searchBox(),
                (_buddies.length == 0)
                    ? Container(
                        decoration: BoxDecoration(
                            //color: Colors.greenAccent,
                            border: Border.all(
                                color: Colors.pink[300], width: 1.5)),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(30),
                        //color: Colors.green[100],
                        child: Text(
                          """SEARCH WITH EXACT FULL NAME. 

We believe in privacy. We keep users' profile hidden, making it hard to be followed by unknown users randomly. Only the one, provided with an authentic user ID, can access a specific user. 
We strongly recommend you to make your user name unique and complex, so that unknown people can't guess it and follow you. Share it only with your trusted friends. 
For any suggestion, please contact us on smsehab0@gmail.com .
                    """,
                          //textAlign: TextAlign.center,
                          softWrap: true,
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          )),
                        ))
                    : Expanded(
                        child: ListBuilder(
                          _buddies,
                          _user.uid,
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
                  borderSide: BorderSide(color: Colors.indigo[400], width: 2.0),
                )),
            onChanged: (val) {
              setState(() {
                searchName = val;
              });
            }));
  }
}
// Part of pagination-helper widget, may need later.................
//   return Column(
//     children: [
//       searchBox(),
//       Expanded(
//         child: PaginateFirestore(
//           itemBuilder: (index, context, doc) {
//             Buddy buddy = Buddy(
//                     uid: doc['uid'] ?? null,
//                     name: doc['name'] ?? null,
//                     bio: doc['bio'] ?? null,
//                     location: doc['location'] ?? null,
//                     time: doc['time'] ?? null,
//                     image: doc['image'] ?? null,
//                     friends: doc['friends']) ??
//                 null;

//             return listTile(buddy, _user.uid);
//           },
//           query: //(searchName != "" && searchName != null)
//               // ?
//               DatabaseService()
//                   .buddyCollection
//                   .orderBy('bio')
//                   .where('name', isEqualTo: searchName)
//           // : DatabaseService()
//           //     .buddyCollection
//           //     .orderBy('name') //.snapshots(),
//           ,
//           itemBuilderType: PaginateBuilderType.listView,
//           isLive: true,
//           //reverse: true,
//         ),
//       ),
//     ],
//   );
// }
