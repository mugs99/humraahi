import 'package:carpoolapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Prof extends StatefulWidget {
  @override
  _ProfState createState() => _ProfState();
}

class _ProfState extends State<Prof> {
  @override
  Widget build(BuildContext context) {
    
    final prof = Provider.of<UserData>(context);
    
    return Text(
        prof.name
    );
  }
}
