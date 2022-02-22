import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:simo_v_7_0_1/providers/provider_two.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:simo_v_7_0_1/uploadingImagesAndproducts.dart';

class AdminAddProduct extends StatefulWidget {
  static const String id = '/HomeForUser';

  @override
  _AdminAddProductState createState() => _AdminAddProductState();
}

class _AdminAddProductState extends State<AdminAddProduct> {
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
                  : ClipRRect(
                      child: Image.asset('assets/iconPlaceholder12.png',
                          fit: BoxFit.fill),
                    )),
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
  String? nombre;
  String? marca;
  String? contenido;
  String? typo_impuesto;
  String? porciento_impuesto;
  String? precio_ahora;
  String? hay_descuento;
  String? precio_anterior;
  String? descripcion;
  final _formKeyAddProduct = GlobalKey<FormState>();


  String? categoryvalue ;
  String messageCategory='';
  void showTextField(context ) {
    showDialog(
        context: context,
        builder: (context ) {
          return AlertDialog(
           title: Text('Anadir una categoria nueva'),
            content: TextField(
              autofocus: true,
              onChanged: (value)
              { categoryvalue=value;},
            ),
            actions: [

              ElevatedButton(
                  onPressed: () async {
                  if (categoryvalue!=null){
                   messageCategory =   await ProductUploadingAndDispalyingFunctions().addNewcategory(categoryvalue!);
                   showMessage(context , messageCategory);
                   context.read<ProviderTwo>().initialValues();
                   await context.read<ProviderTwo>().bringproductos();

                  } else{
                    messageCategory='El texto es vacio .Intenta de nuevo'; showMessage(context , messageCategory);}

                  },
                  child: Text('enviar')),

              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: Text('cancel'))
            ],
          );
        });
  }

  void showMessage(context ,String message) {
    showDialog(
        context: context,
        builder: (context ) {
          return AlertDialog(
            content: Text(message),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(AdminAddProduct.id, (Route<dynamic> route) => false);
                    context.read<ProviderTwo>().initialValues();
                    await context.read<ProviderTwo>().bringproductos();

                  },
                  child: Text('Ok')),
            ],
          );
        });
  }







  @override
  Widget build(BuildContext context) {
    context.read<ProviderTwo>().bringproductos();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontFamily: 'OpenSans'),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProviderTwo>().initialValues();
          await context.read<ProviderTwo>().bringproductos();
        },
        child: Consumer<ProviderTwo>(builder: (context, value, child) {
          return value.map.isEmpty && !value.error
              ? Center(child: CircularProgressIndicator())
              : value.error
                  ? Text('OPs Something went wrong ${value.errorMessage}')
                  : Form(
                      key: _formKeyAddProduct,
                      child: ListView(
                        children: [
                          SizedBox(height: 20,),
                          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                              buildImageContainer(), SizedBox(width: 4.0,),
                              IconButton(icon: Icon(Icons.clear, size: 40.0, color: Colors.red,), onPressed: () {setState(() {imageFile = null;});},),],),
                          SizedBox(height: 20,),
//========================================Category name  1  ===================================================================================
                          DropdownButtonFormField<String>(decoration: InputDecoration(hintText: 'Escoger la categoria', label: Text('Categoria',
                                  style: TextStyle(fontSize: 20, color: Colors.blue),),
                                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),
                                   value: selectedCategory,
                                    onChanged: (value) {selectedCategory = value!;setState(() {});},
                                   validator: (value){
                                   if(selectedCategory ==null)
                                    {return 'Este campo es obligatorio';}
                                    else{return null;}},
                              items: value.map['categorias'].map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                                value: value["id"].toString(),
                                child: Text(value["nombre_categoria"].toString()),)).toList()),
                          SizedBox(height: 4,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(onPressed: (){
                                showTextField(context);
                                }, icon: Icon(Icons.add,size: 40.0,color: Colors.green,)),
                              SizedBox(width: 20,),
                              Text('Anadir una categoria nueva',style: TextStyle(fontSize: 20.0),)
                            ],
                          ),
                          SizedBox(height: 6,),

//======================================================================nombre   2  ============================================
                          TextFormField(
                            keyboardType: TextInputType.text, textInputAction: TextInputAction.done,
                            onSaved: (text) {setState(() {nombre = text;});},
                            validator: (value) {if (value == null || value.trim().isEmpty) {return 'Este campo es obligatorio';}
                            else if (value.length > 32) {return "Los caracteres del texto deben ser menos de 32";} else {return null;}},
                            decoration: InputDecoration(hintText: 'Nombre', label: Text('Nombre',
                                style: TextStyle(fontSize: 20, color: Colors.blue),),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),),
                          SizedBox(height: 20,),
// //======================================================================      "marca"           3 ===========================================

                          TextFormField(keyboardType: TextInputType.text, textInputAction: TextInputAction.done,
                            onSaved: (text) {setState(() {marca = text;});},
                            validator: (value) {if (value == null || value.trim().isEmpty) {
                                return 'Este campo es obligatorio';} else if (value.length > 32) {
                                return "Los caracteres del texto deben ser menos de 32";} else {return null;}},
                            decoration: InputDecoration(hintText: 'marca',
                              label: Text('marca', style: TextStyle(fontSize: 20, color: Colors.blue),),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),),
                          SizedBox(height: 20,),
// //======================================================================      "contenido"           4 ===========================================
                          TextFormField(keyboardType: TextInputType.text, textInputAction: TextInputAction.done,
                            onSaved: (text) {setState(() {contenido = text;});},
                            validator: (value) {if (value == null || value.trim().isEmpty) {return 'Este campo es obligatorio';}
                            else if (value.length > 32) {
                                return "Los caracteres del texto deben ser menos de 32";} else {return null;}},
                            decoration: InputDecoration(hintText: 'contenido', label: Text('contenido',
                                style: TextStyle(fontSize: 20, color: Colors.blue),),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),),
                          SizedBox(height: 20,),
// //=====================================================================   "typo_impuesto"    5 ============================================
                          DropdownButtonFormField<String>(decoration: InputDecoration(hintText: 'Escoger typo de impuesto',
                            label: Text('Typo de impuesto', style: TextStyle(fontSize: 20, color: Colors.blue),
                                ), border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),), value: selectedTaxType,
                              validator: (value){
                                if(selectedTaxType ==null) {return 'Este campo es obligatorio';} else{return null;}},
                              onChanged: (value) {selectedTaxType = value!;setState(() {});},
                              items: taxTypesList.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(value: value.toString(),
                                            child: Text(value.toString()),)).toList()),
                          SizedBox(height: 20,),
// //==================================================================="porciento_impuesto"      6 ============================================
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onSaved: (text) {setState(() {porciento_impuesto = text;});},
                            // validator: (value) {if (value == null || value.trim().isEmpty)
                            //   return 'Es obligatorio llenarse este campo';
                            // String pattern = r'[0-9]+[\.][0-9]{2})';
                            // if(!RegExp(pattern).hasMatch(value)) return 'Entrada invalida';return null;},
                            decoration: InputDecoration(hintText: 'porciento_impuesto', label: Text('porciento_impuesto',
                                style: TextStyle(fontSize: 20, color: Colors.blue),), border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),),),
                          SizedBox(height: 20,),
// //================================================================== "precio_ahora"         7  ===========================================
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onSaved: (text) {setState(() {precio_ahora = text;});},
                            // validator:
                            //     (value) {if (value == null || value.trim().isEmpty)
                            //     return 'Es obligatorio llenarse este campo';
                            //   String pattern = r'[-+]?([0-9]*\.[0-9]+|[0-9]+)';
                            //   if(!RegExp(pattern).hasMatch(value)) return 'Entrada invalida';return null;},
                            decoration: InputDecoration(hintText: 'precio_ahora',
                              label: Text('precio_ahora', style: TextStyle(fontSize: 20, color: Colors.blue),),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),),
                          SizedBox(height: 20,),

//================================================================== "precio_anterior"    9 ==========================================
                          TextFormField(
                            keyboardType: TextInputType.text, textInputAction: TextInputAction.done,
                            onSaved: (text) {setState(() {precio_anterior = text;});},
                            // validator: (value) {if (value == null || value.trim().isEmpty)
                            //   return 'Es obligatorio llenarse este campo';
                            // String pattern = r'[-+]?([0-9]*\.[0-9]+|[0-9]+)';
                            // if(!RegExp(pattern).hasMatch(value)) return 'Entrada invalida';return null;},
                            decoration: InputDecoration(hintText: 'precio_anterior',
                              label: Text('precio_anterior', style: TextStyle(fontSize: 20, color: Colors.blue),),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),),
                          SizedBox(height: 20,),

// //================================================================ "descripcion"   11=========================================
                          TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onSaved: (text) {setState(() {descripcion = text;});},
                            validator: (value) {if (value == null || value.trim().isEmpty) {return 'Este campo es obligatorio';
                              } else if (value.length > 32) {return "Los caracteres del texto deben ser menos de 32";} else {return null;}},
                            decoration: InputDecoration(hintText: 'Descripcion',
                              label: Text('Descripcion', style: TextStyle(fontSize: 20, color: Colors.blue),),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),),),
                          SizedBox(height: 20,),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKeyAddProduct.currentState!.validate()) {
                                _formKeyAddProduct.currentState!.save();
                                calculationDiscountAndtaxes();

                                if (imageFile != null) {
                                  String message =
                                      await ProductUploadingAndDispalyingFunctions()
                                          .uploadANewProductWithAnImage(
                                    imageFile!,
                                    selectedCategory == null
                                        ? ''
                                        : selectedCategory!,
                                    nombre == null ? '' : nombre!,
                                    marca == null ? '' : marca!,
                                    contenido == null ? '' : contenido!,
                                    selectedTaxType == null
                                        ? ''
                                        : selectedTaxType!,
                                    porciento_impuesto == null
                                        ? ''
                                        : porciento_impuesto!,
                                    Taxvalue.toString(),
                                    precio_ahora == null ? '' : precio_ahora!,
                                    price_with_no_tax.toString(),
                                    selectedDiscuento == null
                                        ? 'no'
                                        : selectedDiscuento!,
                                    precio_anterior == null
                                        ? ''
                                        : precio_anterior!,
                                    discountinPercentage.toString(),
                                    descripcion == null ? '' : descripcion!,
                                  );
                                  showstuff(context, message);
                                } else {
                                  String message =
                                      await ProductUploadingAndDispalyingFunctions()
                                          .uploadANewProductWithoutImage(
                                    selectedCategory == null
                                        ? ''
                                        : selectedCategory!,
                                    nombre == null ? '' : nombre!,
                                    marca == null ? '' : marca!,
                                    contenido == null ? '' : contenido!,
                                    selectedTaxType == null
                                        ? ''
                                        : selectedTaxType!,
                                    porciento_impuesto == null
                                        ? ''
                                        : porciento_impuesto!,
                                    Taxvalue.toString(),
                                    precio_ahora == null ? '' : precio_ahora!,
                                    price_with_no_tax.toString(),
                                    selectedDiscuento == null
                                        ? 'no'
                                        : selectedDiscuento!,
                                    precio_anterior == null
                                        ? ''
                                        : precio_anterior!,
                                    discountinPercentage.toString(),
                                    descripcion == null ? '' : descripcion!,
                                  );

                                  showstuff(context, message);
                                }
                              }
                            },
                            child: Text('Enviar '),
                          ),
                        ],
                      ),
                    );
        }),
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
    if (double.parse('$precio_ahora') > 0 &&
        double.parse('$precio_anterior') > 0 &&
        double.parse('$precio_ahora') < double.parse('$precio_anterior')) {
      discountinPercentage = calculateDiscount(
          double.parse('$precio_ahora'), double.parse('$precio_anterior'));
    } else {
      discountinPercentage = 0;
    }
    print(
        'discountInPercentage ====================================$discountinPercentage %');

    Taxvalue = 0;
    if (double.parse('$precio_ahora') > 0 &&
        double.parse('$precio_ahora') != null &&
        double.parse('$porciento_impuesto') > 0 &&
        double.parse('$porciento_impuesto') != null &&
        double.parse('$porciento_impuesto') < 900) {
      Taxvalue = value_of_tax(
          double.parse('$precio_ahora'), double.parse('$porciento_impuesto'));
    } else {
      Taxvalue = 0;
    }
    print('Taxvalue ====================================$Taxvalue');

    price_with_no_tax = 0;
    if (double.parse('$precio_ahora') > 0 &&
        double.parse('$porciento_impuesto') > 0 &&
        double.parse('$precio_ahora') != null) {
      price_with_no_tax =
          value_price_with_no_tax(double.parse('$precio_ahora'), Taxvalue);
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
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushNamedAndRemoveUntil(DisplayProductsToBeEdited.id, (Route<dynamic> route) => false);
                    // context.read<ProviderTwo>().initialValues();
                    // await context.read<ProviderTwo>().bringproductos();
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }
}
