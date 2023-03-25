import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxilk/DataHandler/AppData.dart';
import 'package:taxilk/Models/address.dart';


import '../configMaps.dart';
import 'RequestAssistant.dart';

class AssistantMethods{
  static Future<String>searchcoordinateAddress(Position position,context)async{
    String placeAddress="";
    String st1,st2,st3,st4;
    String url="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    var response=await RequestAssistant.getRequest(url);
    if(response!="failed"){
//placeAddress=response["results"][0]["formatted_address"];
      st1=response["results"][0]["address_components"][0]["long_name"];
      st2=response["results"][0]["address_components"][1]["long_name"];
// st3=response["results"][0]["address_components"][5]["long_name"];
      st4=response["results"][0]["address_components"][6]["long_name"];
      placeAddress=st1+", "+st2+","+st4;

      Address userpickedAddress=new Address();
      userpickedAddress.longitude=position.longitude;
      userpickedAddress.latitude=position.latitude;
      userpickedAddress.placeName=placeAddress;
      Provider.of<AppData>(context,listen: false).updatePickuplocationAddress(userpickedAddress);

    }
    return placeAddress;
  }}