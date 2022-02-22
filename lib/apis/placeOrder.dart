import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simo_v_7_0_1/modals/cart_model.dart';
import 'package:simo_v_7_0_1/modals/product_model.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';




class PlaceOrder{


  Future  placeOrder( {
    final  List<CartModel>?  cartModeList,
   int ? user_id,
   String? full_name,
   String? address,
   String? city,
   String? departement,
   String? country,
   String? phone,
  int? status,
  String? message,
   double? grand_total,
  double? grand_total_base,
 double? grand_total_taxes,
  double? grand_total_discount



}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? spToken = await prefs.getString('spToken');
    print('sptoken ========================$spToken');

    final url = Uri.parse(
        'http://192.168.1.22/api_v_1/public/client/placeOrder');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $spToken',
    };




    Map<String, dynamic> body = {



       'cartModelList': cartModeList,
        'user_id':user_id,
         'full_name':full_name,
        'address':address,
      'city':city,
      'departement':departement,
      'country':country,
      'phone':phone,
      'status':status,
      'message':message,

        'grand_total': grand_total,
      'grand_total_base': grand_total_base,
      'grand_total_taxes': grand_total_taxes,
      'grand_total_discount':grand_total_discount
    };


    final response = await http.post(url, headers: headers, body: jsonEncode(body));
    var json = jsonDecode(response.body);
    print ('json=======================$json');

    return  json;
  }









}




