import 'package:flutter/cupertino.dart';
import 'package:taxilk/Models/address.dart';

class AppData extends ChangeNotifier{

  Address pickUplocation;
  void updatePickuplocationAddress(Address pickUpAddress) {
    pickUplocation = pickUpAddress;
    notifyListeners();
  }
}