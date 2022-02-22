import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/src/provider.dart';
import 'package:simo_v_7_0_1/apis/getProduct.dart';
import 'package:simo_v_7_0_1/modals/cart_model.dart';
import 'package:simo_v_7_0_1/modals/json_products_plus_categories.dart';
import 'package:simo_v_7_0_1/modals/product_model.dart';
import 'package:simo_v_7_0_1/providers/provider_two.dart';
import 'package:flutter/material.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';
import 'package:simo_v_7_0_1/screens/cart_screen.dart';
import 'package:simo_v_7_0_1/screens/selected_product_details.dart';
import 'package:simo_v_7_0_1/widgets_utilities/multi_used_widgets.dart';

import 'package:simo_v_7_0_1/widgets_utilities/user_app_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserCatalogue extends StatefulWidget {
  const UserCatalogue({Key? key}) : super(key: key);
  static const String id = '/ userpage';
  @override
  State<UserCatalogue> createState() => _UserCatalogueState();
}

class _UserCatalogueState extends State<UserCatalogue> {


  Future<ProductsAndCategories> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? spToken = await prefs.getString('spToken');
    final Map<String, String> _userprofileHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $spToken',
    };
    Uri _tokenUrl = Uri.parse(
        'http://192.168.1.22/api_v_1/public/client/user/showproductsusers');
    http.Response response =
        await http.post(_tokenUrl, headers: _userprofileHeader);
    var jsondata = jsonDecode(response.body);
    ProductsAndCategories productsAndCategories =
        ProductsAndCategories.fromjson(jsondata);

    return productsAndCategories;
  }

  Map<String, dynamic> map = {};
  Future<Map<String, dynamic>> getProductsUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? spToken = await prefs.getString('spToken');
    final Map<String, String> _userprofileHeader = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $spToken',
    };
    Uri _tokenUrl = Uri.parse(
        'http://192.168.1.22/api_v_1/public/client/user/showproductsusers');
    http.Response response =
        await http.post(_tokenUrl, headers: _userprofileHeader);
    map = jsonDecode(response.body);
    return map;
  }

  void showstuff(context, var myString) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: myString == null
                ? ClipRect(
                    child: Image.asset('assets/iconPlaceholder12.png'),
                  )
                : ClipRect(
                    child: Image.network(
                        'http://192.168.1.22/api_v_1/storage/app/public/notes/$myString'),
                  ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Center(child: Text('Ok')))
            ],
          );
        });
  }

  Row _buildProductPropertiesCategory(String propertyName, var propertyApi) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$propertyName : ',
          style: TextStyle(
              fontStyle: FontStyle.italic, color: Colors.black, fontSize: 16),
        ),
        Text(
          propertyApi == null
              ? 'No espificada'
              : propertyApi['nombre_categoria'],
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }

  Row _buildProductPropertiesOthers(String propertyName, var propertyApi) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$propertyName : ',
          style: TextStyle(
              fontStyle: FontStyle.italic, color: Colors.black, fontSize: 16),
        ),
        Text(
          propertyApi == null ? 'No espficada' : propertyApi,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }

  Row _buildProductPropertiesPreviousPrice(
      String propertyName, var propertyApi) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$propertyName : ',
          style: TextStyle(
              fontStyle: FontStyle.italic, color: Colors.black, fontSize: 16),
        ),
        RichText(
          text: TextSpan(
            text: '$propertyApi \$',
            style: new TextStyle(
              fontSize: 20,
              color: Colors.red,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
    );
  }

  Row _buildProductPropertiesDescuent(String propertyName, var propertyApi) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$propertyName : ',
          style: TextStyle(
              fontStyle: FontStyle.italic, color: Colors.black, fontSize: 16),
        ),
        Text(
          propertyApi == null ? 'No espficada' : '$propertyApi %',
          style: TextStyle(color: Colors.green, fontSize: 20),
        ),
      ],
    );
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Product> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = list;
    } else {
      results = list
          .where((element) => element.nombre_producto!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      listOnSearch = results;
    });
  }

  List<Product> listOnSearch = [];
  List<Product> list = [];

  late int quantityLocal;
  @override
  void initState() {
    GetProduct().getProductsList().then((value) {
      setState(() {
        list = value;
        listOnSearch = list;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    quantityLocal = context.watch<ShoppingCartProvider>().countMap;
   var  mymap = context.watch<ShoppingCartProvider>().collectionMap;

    return Scaffold(
      appBar: UserAppBar(mytext:'Home page',arrow: false,),
      body: list.isEmpty
          ? Center(child: Text('No hay productos en el inventario'))
          :



      Column(
              children: [


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      _runFilter(value);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),

                Expanded(
                  child: listOnSearch.isNotEmpty
                      ? ListView.builder(

                          itemCount: listOnSearch.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 20,
                              child: ListTile(
                                //===========================================================================================
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      SelectedProductDetails.id,
                                      arguments: listOnSearch[index]);
                                },
                                leading: TextButton(
                                  onPressed: () {
                                    showstuff(context,
                                        listOnSearch[index].foto_producto);
                                  },
                                  child: Container(
                                      child:
                                          listOnSearch[index].foto_producto ==
                                                  null
                                              ? CircleAvatar(

                                                  backgroundImage: AssetImage(
                                                      'assets/iconPlaceholder12.png'),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 30.0,
                                                )
                                              : CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundImage: NetworkImage(
                                                      'http://192.168.1.22/api_v_1/storage/app/public/notes/${listOnSearch[index].foto_producto}'),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                )),

                                ),
                                title: Column(
                                  children: [

                                    Text(
                                       '${listOnSearch[index].nombre_producto}',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                    ),
                                    Text(
                                      '${listOnSearch[index].precio_ahora}\$',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                    ),
                                    listOnSearch[index].porciento_de_descuento==null? Text(''):
                                    Text(
                                      '${listOnSearch[index].porciento_de_descuento}\%',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                    ),
                                    listOnSearch[index].categoria_id==null?Text(''): Text(
                                      listOnSearch[index].categoria_id.toString(),
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 18),
                                    ),


                                  ],
                                ),




                                trailing: Icon(Icons.more_horiz),
                              ),
                            );

//=========================================================== CARD AND EXPANSION TILE END==================================================
                          })
                      : const Text(
                          'No results found',
                          style: TextStyle(fontSize: 24),
                        ),
                ),
              ],
            ),
    );
  }
}
