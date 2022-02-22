import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simo_v_7_0_1/modals/cart_model.dart';



class SharedPrefrencedProvider extends ChangeNotifier{

  //variables

  int? _userId;
  String? _userName;
  String? _userEmail;

  //Getters
  int? get userId {return _userId;}
  String? get userName {return _userName;}
  String? get userEmail {return _userEmail;}

  // function
  Future  getInstanceOfSP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = await prefs.getInt('id');
    _userName = await prefs.getString('username');
    _userEmail= await prefs.getString('email');

    notifyListeners();

  }

}