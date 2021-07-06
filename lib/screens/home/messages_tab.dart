import 'package:carpoolapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carpoolapp/shared/loading.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
User chatter;

class messagesTab extends StatefulWidget {
  String temp;
  String tempName;
  String tempPath;
  messagesTab({this.temp,this.tempName,this.tempPath});
  @override
  _messagesTabState createState() => _messagesTabState(temp1: temp, temp1Name: tempName, temp1Path: tempPath);
}

class _messagesTabState extends State<messagesTab> {
  @override
  final messageTextController = TextEditingController();
  final AuthService _auth = AuthService();

  _messagesTabState({this.temp1,this.temp1Name,this.temp1Path});

  String temp1;
  String temp1Name;
  String temp1Path;
  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void setChatter(User temp) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
        onPressed: () { Navigator.pop(context);},
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.deepOrangeAccent,
              child: ClipOval(
                child: SizedBox(
                  width: 180.0,
                  height: 180.0,
                  child: (temp1Path == '') ? Loading() : Image.network(temp1Path,fit: BoxFit.cover,),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(temp1Name, style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(temp2: temp1,),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left:8.0,bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            fillColor: Colors.lightBlueAccent,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none
                              ),
                            ),
                          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            hintText: 'Enter a message...',
                          hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                        ),
                        onChanged: (value) {
                          messageText = value;
                        },
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messageTextController.clear();
                        if(messageText != null && messageText != ""){
                        _firestore.collection('users').doc(loggedInUser.uid).collection('messages').add({
                          'text': messageText,
                          'id': temp1,
                          'from': loggedInUser.uid,
                          'to': temp1,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        print('Current User ka data is added: ' + loggedInUser.uid);
                        FirebaseFirestore.instance.collection('users').doc(temp1).collection('messages').add({
                          'text': messageText,
                          'id': loggedInUser.uid,
                          'from': loggedInUser.uid,
                          'to': temp1,
                          'timestamp': FieldValue.serverTimestamp(),
                        }).then((value) => print('Second User ka data is added: ' + temp1));
                        print('Second User ka data is added: ' + temp1);
                        messageTextController.clear();
                      }
                        },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent,
                          border: Border.all(
                            color: Colors.deepOrangeAccent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Send', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {

  MessagesStream({this.temp2});

  String temp2;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').doc(loggedInUser.uid).collection('messages').orderBy("timestamp").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Loading(),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          if (message.data()['id'] == temp2 ||
              message.data()['id'] == loggedInUser.uid) {
            final messageText = message.data()['text'];
            final messageSender = message.data()['from'];
            final timestamp = message.data()['timestamp'];

            final currentUser = loggedInUser.uid;
            print(loggedInUser.uid);
            print(messageSender);

            final messageBubble = MessageBubble(
              timestamp: timestamp,
              text: messageText,
              isMe: currentUser == messageSender,
            );

            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.timestamp, this.text, this.isMe});

  final Timestamp timestamp;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          (timestamp == null) ? SizedBox(height: 0,) : Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              timestamp.toDate().toString().substring(0,(timestamp.toDate().toString().length - 7)),
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          (timestamp == null) ? SizedBox(height: 0,) : Material(
            borderRadius: isMe
                ? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
