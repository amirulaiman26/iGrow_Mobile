// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';

// import 'info_group.dart';
// import 'group_model.dart';

// Future<List<Group>?> getGroup() async {
//   final response =
//       await http.get(Uri.parse('https://retoolapi.dev/1WVaql/group'));

//   if (response.statusCode == 200) {
//     List jsonResponse = json.decode(response.body);
//     // return jsonResponse.map((data) => new Group.fromJson(data)).toList();
//   } else {
//     throw Exception('Unexpected error occured!');
//   }
// }

// class GroupJoined extends StatefulWidget {
//   @override
//   _GroupJoinedState createState() => _GroupJoinedState();
// }

// class _GroupJoinedState extends State<GroupJoined> {
//   late Future<List<Group>?> futureGroup;

//   @override
//   void initState() {
//     super.initState();
//     futureGroup = getGroup();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: FutureBuilder<List<Group>?>(
//           future: futureGroup,
//           builder: (context, AsyncSnapshot snapshot) {
//             if (snapshot.hasData) {
//               List<Group> data = snapshot.data;
//               return ListView.builder(
//                   itemCount: data.length,
//                   itemBuilder: (BuildContext context, int index) => Card(
//                       elevation: 6,
//                       margin: EdgeInsets.all(10),
//                       child: ListTile(
//                         leading: Icon(
//                           Icons.camera_alt,
//                           size: 40,
//                         ),
//                         title: Text(data[index].name),
//                         subtitle: Text(data[index].id.toString()),
//                         trailing: Icon(Icons.add),
//                         onTap: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => InfoGroupJoined(group: data[index],)
//                             ));
//                         },
//                       )));
//             } else if (snapshot.hasError) {
//               return Text('${snapshot.error}');
//             }

//             return const CircularProgressIndicator();
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_auth/Screens/group/group_feed.dart';

class GroupJoined extends StatefulWidget {
  @override
  _GroupJoinedState createState() => _GroupJoinedState();
}

class _GroupJoinedState extends State<GroupJoined> {
  @override
  Widget build(BuildContext context) {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    Stream<QuerySnapshot> group = FirebaseFirestore.instance
        .collection('group')
        .where(
          "joined_uid",
          arrayContains: user,
        )
        .snapshots();

    return Scaffold(
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
        stream: group,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          } else {
            // return Text("Testing ...");
            final data = snapshot.requireData;

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: data.size,
              itemBuilder: (BuildContext context, int index) => Card(
                elevation: 6,
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(
                    Icons.group,
                    size: 30,
                  ),
                  title: Text("${data.docs[index]['name']}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupFeed(
                                docid: snapshot.data!.docs[index],
                              )),
                    );
                  },
                ),
              ),
            );
          }
        },
      )),
    );
  }
}
