import 'package:carpoolapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carpoolapp/models/chatdata.dart';
import 'package:carpoolapp/screens/home/pre_message_tab.dart';

class prepreMessageTab extends StatefulWidget {
  @override
  _prepreMessageTabState createState() => _prepreMessageTabState();
}

class _prepreMessageTabState extends State<prepreMessageTab> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ChatData>>.value(
      value: DatabaseService().chatData,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: preMessageTab(),
      ),
    );
  }
}