
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:simo_v_7_0_1/providers/provider_two.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'admin_show_products_edit_delet.dart';
import 'package:simo_v_7_0_1/uploadingImagesAndproducts.dart';

class AdminEditProduct extends StatefulWidget {
  static const String id = '/editproduct';

  @override
  _AdminEditProductState createState() => _AdminEditProductState();
}

class _AdminEditProductState extends State<AdminEditProduct> {
  final scaffoldKeyUnique = GlobalKey<ScaffoldState>();

//ImagePicker
  File? imageFile;

  void pickupImage(ImageSource source) async {
    try {
      final imageFile = await ImagePicker().pickImage(source: source);

      if (imageFile == null) return;
      final imageTemporary = File(imageFile.path);
      setState(() {
        this.imageFile = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('failed to pick up the image :$e');
    }
  }

  //Sheet function
  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: new Icon(Icons.photo_camera_outlined),
                title: new Text('Camera'),
                onTap: () {
                  pickupImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: new Icon(Icons.photo_library_outlined),
                title: new Text('Galeria'),
                onTap: () {
                  pickupImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  Widget buildImageContainer() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 120,
            height: 120,
            child: imageFile != null
                ? ClipOval(
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.fill,
                    ),
                  )
                : productos['foto_producto'] == null
                    ? ClipOval(
                        child: Container(
                            child: Image.asset('assets/placeHolderimage.png',
                                fit: BoxFit.fill)),
                      )
                    : ClipOval(
                        child: Container(
                            child: Image.network(
                                'http://192.168.1.22/api_v_1/storage/app/public/notes/${productos['foto_producto']}',
                                fit: BoxFit.fill)),
                      ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showPicker(context);
          },
          child: ClipOval(
              child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.green,
                  child: Image.asset('assets/edit.png', fit: BoxFit.fill))),
        ),
      ],
    );
  }

  List taxTypesList = ['IVA', 'Impoconsumo', 'Exento'];
  List yesNoList = [' SI ', ' NO '];
  double discountinPercentage = 0;
  double Taxvalue = 0;
  double price_with_no_tax = 0;
  final _formKey = GlobalKey<FormState>();
  // Map<String, dynamic> jo = {};
  String? selectedCategory;
  String? selectedDiscuento;
  String? selectedTaxType;
  String ? nombre ;
  String ? marca;
  String ? contenido ;
  String ? typo_impuesto ;
  String ? porciento_impuesto ;
  String ? precio_ahora ;
  String ? hay_descuento ;
  String ? precio_anterior ;
  String ? descripcion ;
  int? idOfCategory;
  int? idOfProduct;
  var  productos ;
  var  categorias ;
    var jo;


  @override
  Widget build(BuildContext context) {

     jo= ModalRoute.of(context)!.settings.arguments;

     idOfCategory = jo[0]['categoria_id'];
     idOfProduct = jo[0]['id'];
     productos =jo[0];
      categorias=jo[1];



    return jo.isEmpty
        ? Center(child: CircularProgressIndicator()):
    Scaffold(
        key: scaffoldKeyUnique,
        appBar: AppBar(

          title:productos == null
              ? Text('Loading')
              : Text(
            productos['nombre_producto'],
                  style: TextStyle(fontSize: 20.0),
                ),
          centerTitle: true,
        ),
         body: Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                       Row(
                         mainAxisAlignment:MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           buildImageContainer(),
                           SizedBox(width: 4.0,),
                           IconButton(
                             icon: Icon(Icons.clear, size:40.0,color: Colors.red,),
                             onPressed: () {
                               setState(() {
                                 imageFile = null;
                               });
                             },
                           ),
                         ],
                       ),

                      SizedBox(
                        height: 20,
                      ),

                      Text('id =================================: $idOfProduct'),


                      SizedBox(
                        height: 20,
                      ),


//========================================Category name  1  ===================================================================================

                    DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: 'Escoger la categoria',
                          label: Text(
                            'Categoria',
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                       value: idOfCategory==null?selectedCategory:idOfCategory.toString() ,
                       // value: selectedCategory ,

                        onChanged: (value) {
                          //obligatory parameter
                           selectedCategory = value!;
                        // jo['category_name']['id'] = value!;

                          setState(() {});
                        },
                        items: jo[1]
                            .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                          value: value["id"].toString(),
                          child: Text(value["nombre_categoria"].toString()),
                        ))
                            .toList()),



                      SizedBox(height: 20,),
//======================================================================nombre   2  ============================================
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      initialValue: productos['nombre_producto'] ??'',
                      onSaved: (  text) {setState(() {nombre = text;});},
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {return 'Es obligatorio llenarse este campo';}
                        else if (value.length > 26) {return "es largo";} else {return null;}},
                      decoration: InputDecoration(hintText: 'Nombre', label: Text('Nombre', style: TextStyle(fontSize: 20, color: Colors.blue),),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),
                    ),
                      SizedBox(height: 20,),
// //======================================================================      "marca"           3 ===========================================



                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        initialValue: productos['marca'] ??'',
                        onSaved: (  text) {setState(() {marca = text;});},
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {return 'Es obligatorio llenarse este campo';}
                          else if (value.length > 26) {return "es largo";} else {return null;}},
                        decoration: InputDecoration(hintText: 'marca', label: Text('marca', style: TextStyle(fontSize: 20, color: Colors.blue),),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),
                      ),
                      SizedBox(height: 20,),
// //======================================================================      "contenido"           4 ===========================================
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        initialValue: productos['contenido'] ??'',
                        onSaved: (  text) {setState(() {contenido = text;});},
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {return 'Es obligatorio llenarse este campo';}
                          else if (value.length > 26) {return "es largo";} else {return null;}},
                        decoration: InputDecoration(hintText: 'contenido', label: Text('contenido', style: TextStyle(fontSize: 20, color: Colors.blue),),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),
                      ),
                      SizedBox(height: 20,),

// //=====================================================================   "typo_impuesto"    5 ============================================
                      DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Escoger typo de impuesto',
                            label: Text(
                              'Typo de impuesto',
                              style: TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          value: productos['typo_impuesto']==null?selectedTaxType:productos['typo_impuesto'] ,
                          onChanged: (value) {
                            //obligatory parameter
                            selectedTaxType = value!;
                            // jo['category_name']['id'] = value!;

                            setState(() {});
                          },
                          items: taxTypesList //obligatory parameter
                              .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value.toString()),
                          ))
                              .toList()),
                      SizedBox(height: 20,),
// //==================================================================="porciento_impuesto"      6 ============================================
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        initialValue: productos['porciento_impuesto'] ??'',
                        onSaved: (  text) {setState(() {porciento_impuesto = text;});},
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {return 'Es obligatorio llenarse este campo';}
                          else if (value.length > 26) {return "es largo";} else {return null;}},
                        decoration: InputDecoration(hintText: 'porciento_impuesto', label: Text('porciento_impuesto', style: TextStyle(fontSize: 20, color: Colors.blue),),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),
                      ),
                      SizedBox(height: 20,),


// //================================================================== "precio_ahora"         7  ===========================================
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        initialValue: productos['precio_ahora'] ??'',
                        onSaved: (  text) {setState(() {precio_ahora = text;});},
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {return 'Es obligatorio llenarse este campo';}
                          else if (value.length > 26) {return "es largo";} else {return null;}},
                        decoration: InputDecoration(hintText: 'precio_ahora', label: Text('precio_ahora', style: TextStyle(fontSize: 20, color: Colors.blue),),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),
                      ),
                      SizedBox(height: 20,),






//================================================================== "precio_anterior"    9 ==========================================
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        initialValue: productos['precio_anterior'] ??'',
                        onSaved: (  text) {setState(() {precio_anterior= text;});},
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {return 'Es obligatorio llenarse este campo';}
                          else if (value.length > 26) {return "es largo";} else {return null;}},
                        decoration: InputDecoration(hintText: 'precio_anterior', label: Text('precio_anterior', style: TextStyle(fontSize: 20, color: Colors.blue),),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),
                      ),
                      SizedBox(height: 20,),



// //================================================================ "descripcion"   11=========================================

                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        initialValue: productos['descripcion'] ??'',
                        onSaved: (  text) {setState(() {descripcion= text;});},
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {return 'Es obligatorio llenarse este campo';}
                          else if (value.length > 26) {return "es largo";} else {return null;}},
                        decoration: InputDecoration(hintText: 'descripcion', label: Text('descripcion', style: TextStyle(fontSize: 20, color: Colors.blue),),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),
                      ),
                      SizedBox(height: 20,),






                      ElevatedButton(


                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            calculationDiscountAndtaxes();

                            if( idOfProduct!=null){
                              calculationDiscountAndtaxes();

                              if (imageFile != null) {
                                String message =
                                await ProductUploadingAndDispalyingFunctions().UpdateWithImage(

                                  idOfProduct!,
                                  imageFile!,
                                  selectedCategory == null && idOfCategory !=null ? '$idOfCategory' :
                                  selectedCategory==null?'':selectedCategory!,
                                  nombre==null?'':nombre!,
                                  marca==null?'':marca!,
                                  contenido==null?'':contenido!,
                                  selectedTaxType == null && productos['typo_impuesto']!=null ? '${productos['typo_impuesto']}' :
                                  selectedTaxType==null?'':selectedTaxType!,
                                  porciento_impuesto==null?'':porciento_impuesto!,
                                  Taxvalue.toString(),
                                  precio_ahora ==null?'':precio_ahora !, price_with_no_tax.toString(),
                                  selectedDiscuento == null ? 'no' : selectedDiscuento!,
                                  precio_anterior==null?'':precio_anterior!,
                                  discountinPercentage.toString(),
                                  descripcion==null?'':descripcion!,

                                );
                                showstuff(context, message);
                              } else {
                                String message =
                                await ProductUploadingAndDispalyingFunctions().UpdateWithNoImage(

                                  idOfProduct!,
                                  selectedCategory == null && idOfCategory !=null ? '$idOfCategory' :
                                  selectedCategory==null?'':selectedCategory!,
                                  nombre==null?'':nombre!,
                                  marca==null?'':marca!,
                                  contenido==null?'':contenido!,
                                  selectedTaxType == null && productos['typo_impuesto']!=null ? '${productos['typo_impuesto']}' :
                                  selectedTaxType==null?'':selectedTaxType!,
                                  porciento_impuesto==null?'':porciento_impuesto!,
                                  Taxvalue.toString(),
                                  precio_ahora ==null?'':precio_ahora !, price_with_no_tax.toString(),
                                  selectedDiscuento == null ? 'no' : selectedDiscuento!,
                                  precio_anterior==null?'':precio_anterior!,
                                  discountinPercentage.toString(),
                                  descripcion==null?'':descripcion!,

                                );
                                showstuff(context, message);
                              }



                            }else{ return print('No products to be edited');}


                          }
                        }
                       ,

                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber, // Background color
                        ),



                        child: Text('Enviar ', style: TextStyle(fontSize: 40)),
                      ),









                    ],
                  ),
                ),




      ),




    );
  }

// calculating the percentage of descount
  double calculateDiscount(precioAhora, precioAnterior) {
    return ((precioAnterior - precioAhora) / precioAnterior) * 100;
  }

// calculating the value of the tax in currency
  double value_of_tax(precioAhora, percentageOfTax) {
    return precioAhora * (percentageOfTax / 100);
  }

  // calculating the value of price without tax added in currency
  double value_price_with_no_tax(
      precioAhora, resultOfFunctionvalueOfTaxInCurrency) {
    return precioAhora - resultOfFunctionvalueOfTaxInCurrency;
  }


  void calculationDiscountAndtaxes() {
    discountinPercentage = 0;
    if (
        double.parse('$precio_ahora') > 0 &&
        double.parse('$precio_anterior') > 0&&
        double.parse('$precio_ahora') < double.parse('$precio_anterior')

      )
     {
      discountinPercentage = calculateDiscount(double.parse('$precio_ahora'), double.parse('$precio_anterior'));} else {discountinPercentage = 0;}
    print(
        'discountInPercentage ====================================$discountinPercentage %');

    Taxvalue = 0;
    if (double.parse('$precio_ahora') > 0 &&
        double.parse('$precio_ahora') != null &&
        double.parse('$porciento_impuesto') > 0 &&
        double.parse('$porciento_impuesto') != null &&
        double.parse('$porciento_impuesto') < 900) {
      Taxvalue = value_of_tax(double.parse('$precio_ahora'),
          double.parse('$porciento_impuesto'));
    } else {
      Taxvalue = 0;
    }
    print(
        'Taxvalue ====================================$Taxvalue');

    price_with_no_tax = 0;
    if (double.parse('$precio_ahora') > 0 &&
        double.parse('$porciento_impuesto') > 0 &&
        double.parse('$precio_ahora') != null) {
      price_with_no_tax = value_price_with_no_tax(
          double.parse('$precio_ahora'), Taxvalue);
    } else {
      price_with_no_tax = 0;
    }
    print(
        'price_with_no_tax ====================================$price_with_no_tax');
  }



  //notification alert widget
  void showstuff(context, String mynotification) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Notification'),
            content: Text(mynotification),
            actions: [
              ElevatedButton(
                  onPressed: () async {

                    Navigator.of(context).pushNamedAndRemoveUntil(AdminShowProductsEditDelete.id, (Route<dynamic> route) => false);
                    context.read<ProviderTwo>().initialValues();
                    await context.read<ProviderTwo>().bringproductos();

                  },
                  child: Text('Ok'))
            ],
          );
        });
  }








  }




