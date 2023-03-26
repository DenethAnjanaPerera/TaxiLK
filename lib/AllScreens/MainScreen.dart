

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxilk/AllWidgets/DividerWidget.dart';
import 'package:taxilk/AllWidgets/ProgressDialog.dart';
import 'package:taxilk/Assistants/AssistantMethods.dart';
import 'package:taxilk/DataHandler/AppData.dart';
import 'package:taxilk/Models/directionDetails.dart';


import 'SearchScreen.dart';

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
class _State extends State<MainScreen> with TickerProviderStateMixin{
  Completer<GoogleMapController>_controllerGoogleMap=Completer();
  GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState>scaffoldKey=new GlobalKey<ScaffoldState>();
  directionDetails tripDirectionDetails;

  List<LatLng>plineCoordinates=[];
  Set<Polyline>polylineSet={};
  Set<Marker>markersSet={};
  Set<Circle>circleSet={};
  double rideDetailsContainerHeight=0;
  double searchContainerHeight=300.0;
  bool drawerOpen=true;

  void displayRideDetailsContainer()async{
    await getPlaceDirection();
    setState(() {
      searchContainerHeight=0;
      rideDetailsContainerHeight=240.0;
      bottomPaddingOfMap=230.0;
      drawerOpen=false;
    });
  }
  Position currentPosition;
  var geolocator=Geolocator();
  double bottomPaddingOfMap=0;
  void locationPosition()async{
    Position position=await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    currentPosition=position;
    LatLng latLatPosition=LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition=new CameraPosition(target: latLatPosition,zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition
    ));
    String address=await AssistantMethods.searchcoordinateAddress(position,context);
    print("This is your Address ::"+address);
  }
  final CameraPosition _kGooglePlex=CameraPosition(target:
  LatLng(6.927079,79.861244),zoom: 14.4746
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Main Screen"),
        centerTitle: true,
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),child: Row(
                  children: [
                    Image.asset("images/user_icon.png",height: 65.0,width: 65.0,),
                    SizedBox(width: 16.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Profile Name",style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Brand Bold",
                        ),

                        ),SizedBox(height: 6.0,),
                        Text("Visit Profile"),

                      ],
                    ),
                  ],
                ),
                ),
              ), DividerWidget(),
              SizedBox(height: 12.0,),
              ListTile(leading: Icon(Icons.history),title: Text("History",style: TextStyle(
                fontSize: 15.0,
              ),
              ),
              ),
              ListTile(leading: Icon(Icons.person),title: Text(
                "Visit Profile",style: TextStyle(
                fontSize: 15.0,

              ),
              ),
              ),
              ListTile(leading: Icon(Icons.info),title: Text(
                "About",style: TextStyle(
                fontSize: 15.0,

              ),
              ),
              ),
            ],
          ),
        ),

      ),

      body: Stack(
        children: [
          GoogleMap(padding: EdgeInsets.only(bottom: bottomPaddingOfMap),mapType: MapType.normal,myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circleSet,
            initialCameraPosition: _kGooglePlex,onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController=controller;
              setState(() {
                bottomPaddingOfMap=300.0;
              });
              locationPosition();
            },),
          Positioned( top: 38.0,left: 22.0,
            child: GestureDetector(

              onTap: (){
                if(drawerOpen){

                  scaffoldKey.currentState.openDrawer();
                }else{
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),boxShadow: [
                  BoxShadow(
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                        0.7,0.7
                    ),
                  ),

                ]
                ),child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon((drawerOpen)?Icons.menu:Icons.close,color: Colors.black,),radius: 20.0,
              ),
              ),
            ),),
          Positioned(
            left: 0.0,right: 0.0,bottom: 0.0,
            child:

            AnimatedSize(
              vsync: this,curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(

                height: searchContainerHeight,decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 16.0, spreadRadius: 0.5,
                    offset: Offset(
                        0.7,07
                    )),
              ]
              ),child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.0,),
                    Text(
                      "Hi there", style: TextStyle(
                      fontSize: 12.0,
                    ),
                    ),
                    Text(
                      "Where To", style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "Brand Bold",
                    ),
                    ),SizedBox(
                      height: 20.0,
                    ),GestureDetector(
                      onTap: ()async{
                        var res=await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                        if(res=="obtainDirection"){
                          displayRideDetailsContainer();
                        }

                      },
                      child: Container(
                        decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,blurRadius: 6.0,spreadRadius: 0.5,offset: Offset(
                                0.7,0.7,
                              )
                              ),
                            ]
                        ),child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.blueAccent,),
                            SizedBox(width: 10.0,),
                            Text(
                                "Search Drop Off"
                            ),
                          ],
                        ),
                      ),
                      ),
                    ),SizedBox(height: 24.0,),
                    Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.grey,

                        ),SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Provider.of<AppData>(context).pickUplocation!=null?
                            Provider.of<AppData>(context).pickUplocation.placeName:"Add Home", ),
                            SizedBox(height: 4.0,),
                            Text(
                              "Your living home Address",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                    SizedBox(height: 10.0,),
                    DividerWidget(),
                    SizedBox(height: 16.0,),
                    Row(
                      children: [
                        Icon(Icons.work,color: Colors.grey,
                        ),SizedBox(width: 12.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start ,
                          children: [
                            Text("Add work"),
                            SizedBox(height: 4.0,),
                            Text("Your official address",style: TextStyle(
                              color: Colors.black54,fontSize: 12.0,
                            ),),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              ),
            ),),
          Positioned(bottom: 0.0,left: 0.0,right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight:
                    Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black,blurRadius: 16.0,spreadRadius: 0.5,offset: Offset(0.7,
                        0.7,)),
                    ]
                ),child: Padding(
                padding: EdgeInsets.symmetric(vertical: 17.0,),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,color: Colors.tealAccent[100],
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Image.asset("images/taxi.png",height: 70.0,width: 80.0,),
                            SizedBox(width: 16.0,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Car",style: TextStyle(fontSize: 18.0,fontFamily: "Brand-Bold"),),
                                Text((tripDirectionDetails!=null)?tripDirectionDetails.distanceText:'',style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,

                                ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            Text((tripDirectionDetails!=null)?'\$${AssistantMethods.calculatefares(tripDirectionDetails)}':'',style: TextStyle(
                              fontFamily: "Brand-Bold",
                            ),),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20.0),child:
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.moneyCheckAlt,size: 18.0,color: Colors.black54,
                        ),
                        SizedBox(width: 6.0,),
                        Text("Cash"),
                        SizedBox(width: 6.0,),
                        Icon(Icons.keyboard_arrow_down,color: Colors.black54,size: 16.0,),

                      ],
                    ),
                    ),
                    SizedBox(height: 24.0,),
                    Padding(padding:EdgeInsets.symmetric(horizontal: 16.0),child:
                    RaisedButton(
                      onPressed: (){
                        print("Clicked");
                      },
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Request",style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,

                            ),

                            ),Icon(FontAwesomeIcons.taxi,color: Colors.white,
                              size: 26.0,),
                          ],
                        ),
                      ),
                    ), ),
                  ],
                ),
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getPlaceDirection()async {
    var initialPos = Provider
        .of<AppData>(context, listen: false)
        .pickUplocation;
    var finalPos = Provider
        .of<AppData>(context, listen: false)
        .dropOffLocation;
    var pickuplatLang = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOfflatLang = LatLng(finalPos.latitude, finalPos.longitude);
    showDialog(context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Please wait..",)
    );
    var details = await AssistantMethods.obtainplacedirectionDetails(pickuplatLang, dropOfflatLang);
    setState(() {
      tripDirectionDetails=details;
    });
    Navigator.pop(context);
    print("This is Encoded Points::");
    print(details.encodedPoints);
    PolylinePoints polylinePoints=PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult=polylinePoints.decodePolyline(details.encodedPoints);
    plineCoordinates.clear();
    if(decodedPolylinePointsResult.isNotEmpty){
      decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {
        plineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      polylineSet.clear();
      setState(() {
        Polyline polyline=Polyline(color: Colors.pink,polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: plineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,);
        polylineSet.add(polyline);
      });
      LatLngBounds latLngBounds;
      if(pickuplatLang.latitude>dropOfflatLang.latitude&&pickuplatLang.longitude>dropOfflatLang.longitude){
        latLngBounds=LatLngBounds(southwest: dropOfflatLang, northeast: pickuplatLang);
      }else if(pickuplatLang.longitude>dropOfflatLang.longitude){
        latLngBounds=LatLngBounds(southwest:LatLng(pickuplatLang.latitude,dropOfflatLang.longitude
        ), northeast: LatLng(dropOfflatLang.latitude,pickuplatLang.longitude));
      }else if(pickuplatLang.latitude>dropOfflatLang.latitude){
        latLngBounds=LatLngBounds(southwest: LatLng(dropOfflatLang.latitude,pickuplatLang.longitude
        ), northeast: LatLng(pickuplatLang.latitude,dropOfflatLang.longitude));
      }else{
        latLngBounds=LatLngBounds(southwest: pickuplatLang, northeast: dropOfflatLang);
      }
      newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
      Marker pickupLocMarker=Marker(icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),infoWindow:InfoWindow(
        title: initialPos.placeName,snippet: "My Location",
      ), position: pickuplatLang,markerId: MarkerId("pickupID"));
      Marker dropoffLocMarker=Marker(icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),infoWindow:InfoWindow(
        title: finalPos.placeName,snippet: "Drop Off Location",
      ), position: dropOfflatLang,markerId: MarkerId("dropoffID"));
      setState(() {
        markersSet.add(pickupLocMarker);
        markersSet.add(dropoffLocMarker);
      });
      Circle pickupLocCircle=Circle(fillColor: Colors.blueAccent,center: pickuplatLang,radius: 12,strokeWidth: 4,
        strokeColor: Colors.blueAccent,
        circleId: CircleId("pickupID"),
      );
      Circle dropoffLocCircle=Circle(fillColor: Colors.red,center: dropOfflatLang,radius: 12,strokeWidth: 4,
          strokeColor: Colors.deepPurple,
          circleId: CircleId("dropoffID"));
      setState(() {
        circleSet.add(pickupLocCircle);
        circleSet.add(dropoffLocCircle);
      });
    }

  }
  resetApp(){
    setState(() {

      drawerOpen=true;
      searchContainerHeight=300.0;
      rideDetailsContainerHeight=0;
      bottomPaddingOfMap=230.0;
      polylineSet.clear();
      markersSet.clear();
      circleSet.clear();
      plineCoordinates.clear();

    });
    locationPosition();
  }
}