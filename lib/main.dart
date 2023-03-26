import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AllScreens/MainScreen.dart';
import 'AllScreens/LoginScreen.dart';
import 'AllScreens/RegistrationScreen.dart';
import 'DataHandler/AppData.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}
DatabaseReference userRef=FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> AppData(),
      child: MaterialApp(
        title: "Flutter Demo",
        theme: ThemeData(
          fontFamily: "Brand-Bold",
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser==null?LoginScreen.idScreen:
        MainScreen.idScreen,
        routes: {
          RegistrationScreen.idScreen:(context)=>RegistrationScreen(),
          LoginScreen.idScreen:(context)=>LoginScreen(),
          MainScreen.idScreen:(context)=>MainScreen(),


        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }

}