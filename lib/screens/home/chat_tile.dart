import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpoolapp/shared/loading.dart';
import 'package:carpoolapp/screens/home/messages_tab.dart';
import 'package:carpoolapp/models/chatdata.dart';

class ChatTile extends StatelessWidget {

  User user = FirebaseAuth.instance.currentUser;

  final ChatData chat;
  String latestMessage;
  ChatTile({this.chat,this.latestMessage});

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (context)=>messagesTab(temp: chat.uid, tempName: chat.name, tempPath: chat.path))); },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.deepOrangeAccent,
            child: ClipOval(
              child: SizedBox(
                width: 180.0,
                height: 180.0,
                child: (chat.path == '') ? Loading() : Image.network(chat.path,fit: BoxFit.cover,),
              ),
            ),
          ),
          title: Text(chat.name, style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(latestMessage),
        ),
      ),
    );
  }
}