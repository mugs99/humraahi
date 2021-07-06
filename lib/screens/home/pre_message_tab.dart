import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpoolapp/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:carpoolapp/models/chatdata.dart';
import 'package:carpoolapp/screens/home/chat_tile.dart';

final _firestore = FirebaseFirestore.instance;
User user = FirebaseAuth.instance.currentUser;

class preMessageTab extends StatefulWidget {
  @override
  _preMessageTabState createState() => _preMessageTabState();
}

class _preMessageTabState extends State<preMessageTab> {

  int count = 0;
  int chatTileCount = 0;

  @override
  Widget build(BuildContext context) {

    final chats = Provider.of<List<ChatData>>(context);
    Timestamp timestamp = new Timestamp (0,0);
    Timestamp temp;
    String latestMessage = 'sdas';

    return StreamBuilder(
        stream: _firestore.collection('users').doc(user.uid).collection('messages').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: Loading(),
        );
      }
      else{
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            snapshot.data.docs.forEach((doc) {
              print(user.uid);
              if(doc.data()['id'] == chats[index].uid && user.uid != doc.data()['id']){
               temp = doc.data()['timestamp'];
                print('comparing previous timestamp: ${timestamp}');
                print('with new timestamp: ${temp}');
                print('with message: ' + doc.data()['text']);
                if(temp.millisecondsSinceEpoch > timestamp.millisecondsSinceEpoch){
                  timestamp = doc.data()['timestamp'];
                  latestMessage = doc.data()['text'];
                }
                print('This timestamp won: ${timestamp}]');
                print(chats[index].uid);
                print(user.uid);
                print('this is exectuing for some reason');
                ++count;
              }
              });
            timestamp = new Timestamp (0,0);
            if(count>=1){
              print('executing');
              count = 0;
              chatTileCount++;
              return ChatTile(chat: chats[index],latestMessage: latestMessage,);
            }
            else{
              return SizedBox(height: 0.0,);
            }
          }
        );
      }
      }
    );
  }
}
