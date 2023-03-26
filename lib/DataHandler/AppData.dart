import 'package:flutter/cupertino.dart';
import 'package:taxilk/Models/address.dart';

class AppData extends ChangeNotifier{
  Address pickUplocation;
  Address dropOffLocation;
  void updatePickuplocationAddress(Address pickUpAddress){
    pickUplocation=pickUpAddress;
    notifyListeners();
  }
  void updateDropOfflocationAddress(Address dropOffAddress){
    dropOffLocation=dropOffAddress;
    notifyListeners();
  }
}