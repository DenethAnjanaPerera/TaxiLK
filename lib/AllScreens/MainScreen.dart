

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(new MaterialApp(
    home: new MainScreen(),
  ),);
}

class MainScreen extends StatefulWidget{
  static const String idScreen="mainScreen";
  @override
  _State createState()=>new _State();
}
class _State extends State<MainScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Main Screen"),
        centerTitle: true,
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child:
        new Center(
          child:
          new Column(
            children: <Widget>[
              new Text("Taxi App"),
            ],
          ),
        ),
      ),
    );
  }

}