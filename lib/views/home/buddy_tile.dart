// Implement later. 







// import 'package:flutter/material.dart';
// import 'package:kinbo/model/buddy.dart';

// class BuddyTile extends StatelessWidget {
//   //const BuddyTile({ Key? key }) : super(key: key);
//   final Buddy buddy;
//   BuddyTile({this.buddy});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 8.0),
//       child: Card(
//         margin: EdgeInsets.fromLTRB(20.00, 6.00, 20.00, 6.00),
//         child: ListTile(
//           leading: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Color(0xffFDCF09),
//                 child: buddy.image != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(50),
//                         child: Image.network(
//                           buddy.image,
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.fitHeight,
//                         ),
//                       )
//                     : Container(
//                         decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(50)),
//                         width: 100,
//                         height: 100,
//                       ),
//               ),
//           title: Text(buddy.name),
//           subtitle: Text(buddy.bio),
//         ),
//       ),
//     );
//   }
// }
