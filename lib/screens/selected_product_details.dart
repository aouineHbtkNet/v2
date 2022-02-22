
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:simo_v_7_0_1/modals/product_model.dart';
import 'package:simo_v_7_0_1/providers/shopping_cart_provider.dart';
import 'package:simo_v_7_0_1/widgets_utilities/multi_used_widgets.dart';
import 'package:simo_v_7_0_1/widgets_utilities/user_app_bar.dart';

class SelectedProductDetails extends StatefulWidget {
  const SelectedProductDetails({Key? key}) : super(key: key);
  static const String id = '/ selectedProductDetails';
  @override
  _SelectedProductDetailsState createState() => _SelectedProductDetailsState();
}

void showstuff(context, var myString) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: myString == '' || myString == null
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

var  selectedProduct ;
 int quantityLocal =1;

class _SelectedProductDetailsState extends State<SelectedProductDetails> {
  @override
  Widget build(BuildContext context) {
    selectedProduct = ModalRoute.of(context)!.settings.arguments as Product;
    var  mymap = context.watch<ShoppingCartProvider>().collectionMap;



    return selectedProduct == null
        ? Text('Loading')
        : Scaffold(

        appBar: UserAppBar(mytext:'${selectedProduct.nombre_producto}',arrow: true,),





            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 12,
                      child: SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: selectedProduct.foto_producto == null
                                  ? FittedBox(
                                      fit: BoxFit.fill,
                                      child: ClipRect(
                                        child: Image.asset(
                                            'assets/iconPlaceholder12.png'),
                                      ),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.fill,
                                      child: ClipRRect(
                                        child: Image.network(
                                            'http://192.168.1.22/api_v_1/storage/app/public/notes/${selectedProduct.foto_producto}'),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    )),





                          selectedProduct.marca == null ||
                                  selectedProduct.marca== ''
                              ? Text('')
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Marca: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        '${selectedProduct.marca}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                          selectedProduct.nombre_producto == null ||
                                  selectedProduct.nombre_producto == ''
                              ? Text('')
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Nombre: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        '${selectedProduct.nombre_producto}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                          selectedProduct.precio_ahora == null ||
                                  selectedProduct.precio_ahora == ''
                              ? Text('')
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Precio: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        '${selectedProduct.precio_ahora}\$',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                          '${selectedProduct.precio_ahora}' == "0.00"
                              ? SizedBox(
                                  height: 0.0,
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Precio anterior: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text:
                                              '${selectedProduct.precio_anterior} \$',
                                          style: new TextStyle(
                                            fontSize: 30,
                                            color: Colors.red,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          '${selectedProduct.porciento_de_descuento}' == "0.00"
                              ? SizedBox(
                                  height: 0.0,
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Descuento: ',
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        '${selectedProduct.porciento_de_descuento} %',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 30),
                                      ),
                                    ],
                                  ),
                                ),
                          '${selectedProduct.descripcion}' == null
                              ? Text('')
                              : Text(
                                  'Descripcion',
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 20),
                                ),
                          '${selectedProduct.descripcion}' == null
                              ? Text('')
                              : Text(
                                  '${selectedProduct.descripcion} ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                        ],
                      )),
                    ),
                  ),




                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [




                              UsedWidgets().addtocartWidget(context,selectedProduct),






                            ])),
                  ),



          ]
    ))

  );
}}
