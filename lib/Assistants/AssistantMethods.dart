import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxilk/DataHandler/AppData.dart';
import 'package:taxilk/Models/address.dart';
import 'package:taxilk/Models/allUsers.dart';
import 'package:taxilk/Models/directionDetails.dart';
import 'package:http/http.dart' as http;


import '../configMaps.dart';
import 'RequestAssistant.dart';

class AssistantMethods {
  static Future<String> searchcoordinateAddress(Position position,
      context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position
        .latitude},${position.longitude}&key=$mapkey";
    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
//placeAddress=response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
// st3=response["results"][0]["address_components"][5]["long_name"];
      st4 = response["results"][0]["address_components"][6]["long_name"];
      placeAddress = st1 + ", " + st2 + "," + st4;

      Address userpickedAddress = new Address();
      userpickedAddress.longitude = position.longitude;
      userpickedAddress.latitude = position.latitude;
      userpickedAddress.placeName = placeAddress;
      Provider.of<AppData>(context, listen: false).updatePickuplocationAddress(
          userpickedAddress);
    }
    return placeAddress;
  }

  static Future<directionDetails> obtainplacedirectionDetails(LatLng initialPosition,LatLng finalPosition)async{
    String directionUrl="https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=AIzaSyB8gHnZ83HcD5_XNtl7PCpIXvWlNuz0G50&compnents=country:lk";
    // var ress=await RequestAssistant.getRequest(directionUrl);
    // var ress=await Requests.get(url);
    var client = http.Client();
    var response = await client.get(Uri.parse(directionUrl));

    String resp = response.body;
    var ress = json.decode(resp);
    print("ressss"+ress.toString());
    if(ress=="failed"){
      return null;
    }
    directionDetails directiondetailss=directionDetails();
    directiondetailss.distanceText=ress["routes"][0]["legs"][0]["distance"]["text"];
    directiondetailss.distancevalue=ress["routes"][0]["legs"][0]["distance"]["value"];
    directiondetailss.durationText=ress["routes"][0]["legs"][0]["duration"]["text"];
    directiondetailss.durationvalue=ress["routes"][0]["legs"][0]["duration"]["value"];
    directiondetailss.encodedPoints=ress["routes"][0]["overview_polyline"]["points"];
    return directiondetailss;


  }
  static int calculatefares(directionDetails directionDetailss){
    double timeTravelledFare=(directionDetailss.durationvalue/60)*0.20;
    double distanceTravelledFare=(directionDetailss.distancevalue/1000)*0.20;
    double totalFareAmount=timeTravelledFare+distanceTravelledFare;
    //local currency
    // double totalLocalAmount=totalFareAmount*320;
    return totalFareAmount.truncate();
  }
  static void getCurrentOnlineUserInfo()async{
    firebaseuser = await FirebaseAuth.instance.currentUser;
    String userId=firebaseuser.uid;
    DatabaseReference reference=FirebaseDatabase.instance.reference().child("users").child(userId);
    reference.once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.value!=null){
        userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }
}